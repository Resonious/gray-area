{each, all, map, filter, first, head, lines, keys, values} = require 'prelude-ls'

class @GameCore
  (game) !->
    @game = game

  preload: !->
    asset = (p) -> "game/assets/#p"
    @game.load
      ..tilemap 'test-map' (asset 'maps/test-map.json'), null, Phaser.Tilemap.TILED_JSON
      ..image 'test-tiles' asset 'gfx/tiles/black-and-white.png'

      ..image 'black-and-white' asset 'gfx/tiles/black-and-white-big.png'

      ..image 'black' asset 'gfx/tiles/black.png'
      ..image 'white' asset 'gfx/tiles/white.png'
      ..image 'empty' asset 'gfx/tiles/empty.png'
      ..image 'gray'  asset 'gfx/tiles/gray.png'

      ..image 'indicator' asset 'gfx/ui/indicator.png'
      ..image 'locator' asset 'gfx/ui/locator.png'

      ..audio 'hit-ground-1' asset 'sfx/hit-ground-1.ogg'
      ..audio 'jump' asset 'sfx/jump.ogg'
      ..audio 'death' asset 'sfx/death.ogg'
      ..audio 'swap' asset 'sfx/swap.ogg'
      ..audio 'cant-swap' asset 'sfx/cant-swap.ogg'

      ..audio 'bgm' asset 'music/gray.ogg'

      # ..script 'gray-filter' asset 'filters/gray.js'

      ..spritesheet 'player-black' (asset 'gfx/player/black.png'), 84 84
      ..spritesheet 'player-white' (asset 'gfx/player/white.png'), 84 84
      ..spritesheet 'player-gray'  (asset 'gfx/player/gray.png'), 84 84
      # ..spritesheet 'player' (asset 'img/player/player.png'), 32 48
      # ..image 'sky' asset 'img/sky.png'
      # ..image 'ground' asset 'img/ground.png'

  create: !->
    custom-add-functions @game, this

    let (add     = @game.add,
         physics = @game.physics,
         world   = @game.world,
         camera  = @game.camera)

      @bgm = add.audio 'bgm'
        ..play '' 0 0.5 true

      @game.stage.background-color = '#FFFFFF'
      @game.time.advancedTiming = true

      physics.start-system Phaser.Physics.ARCADE

      # @platforms = add.group!
      #   ..add Platform.create.black @game, 135 500 516 74
      #     ..name = "Upper"
      #   ..add Platform.create.black @game, 20  550 700 100
      #     ..name = "Lower"

      # @special-plat = @platforms.add Platform.create.black @game, 20 20 100 100
      #   ..name = "Special"

      @gui = add.group!
        ..fixed-to-camera = true
      @indicator = @gui.create 700 100 'indicator'
        ..anchor.set-to 0.5 0.5
        ..angle = 180

      @swap-sound = add.audio 'swap'
      @cant-swap-sound = add.audio 'cant-swap'

      @arrow-keys = @game.input.keyboard.create-cursor-keys!

      each (~> @game.input.keyboard.add-key(it).on-down.add @switch-players),
           [Phaser.Keyboard.TAB, Phaser.Keyboard.CONTROL]

      @load-level Level.One

  load-level: (level) !->
    if @current-level
      # TODO tween?
      @platforms.destroy!
      @current-level.destroy!
    
    if @locator
      @locator.destroy!

    @platforms = @game.add.group!

    @current-level = @game.add.existing new level(@game, this)

    @locator = @game.add.sprite -100 -100 'locator'
      ..anchor.set-to 0.5 0.5

    [@black-player, @white-player] |> each ~> it.arrow-keys = @get-player-keys it.color

    @game.camera.follow @black-player
    @current-color = \black
    @black-player.current = true
    @white-player.current = false

  update: !->
    # # Protip: do collisions before messing with positions

    let collide = PlatformCollision.collide @game.physics.arcade, @current-level.platforms
      collide @black-player if @black-player
      collide @white-player if @white-player

    [@black-player, @white-player] |> each (player) ~>
      @game.physics.arcade.collide player, @current-level.gray, null, @finish-player

    let player = @current-player!
      if player
        @locator.x = player.x
        @locator.y = player.y - player.body.height

    # DEBUG PLATFORM SSHITITTT
    # let mouse = @game.input.mouse-pointer
    #   if @game.input.mouse-pointer.is-down 
    #     @game.physics.arcade.move-to-pointer @special-plat.inside, 200
    #   else
    #     @special-plat.body.velocity.set-to 0 0

  render: !->
    'ass'
    @game.debug.body @current-level.gray
    # @current-level.platforms |> each (platform) ~>
    #   platform.each @game.debug~body

  debug-log: ->
    console.log ["#key: #value" for key, value of this]
    console.log "====== PLATFORMS ========"
    console.log @current-level.platforms
    @current-level.platforms |> each (platform) ~>
      console.log "#{platform.color} #{platform.x}, #{platform.y}"
    console.log "====== CAMERA ======="
    console.log "#{@game.camera.x}, #{@game.camera.y}"
    '=========== done ==========='

  finish-player: (player) ~>
    return false if player.finished
    player.finish!

    if [@black-player, @white-player] |> all (.finished)
      throw "GAME NEEDS FINISHING"
    else
      @switch-players! if player.current
    false

  current-player: (color) ~> switch color or @current-color
    | \black => @black-player
    | \white => @white-player

  player-colors: <[black white]>
  switch-players: ~>
    const other-color = head filter ~>(it isnt @current-color), @player-colors
    if (@current-player other-color).finished
      @cant-swap-sound.play '' 0 1 false
      return

    @current-player!.current = false
    @current-color = other-color
    @current-player!.current = true
    @game.camera.follow(@current-player!)

    const target = if @current-color is \black then 180 else 0
    @game.add.tween(@indicator)
      ..to {angle: target}, 1000, Phaser.Easing.Quadratic.InOut, true

    @swap-sound.play '' 0 1 false

  get-player-keys: (color) -> 
    ~> if @current-color is color then @arrow-keys else null

  create-gray: (x, y, width = 256, height = 256) ->
    const gray = new Phaser.Sprite(@game, 0, 0, 'gray')
    @game.physics.arcade.enable gray
    gray
      ..anchor.set-to 0.5 0.5
      ..width  = width
      ..height = height
      ..x = x
      ..y = y
      ..body
        ..set-size width * 0.8, width * 0.8

custom-add-functions = (game, core) !->
  <[black white]> |> each (color) ->
    game.add[color] =
      player: (x, y) ->
        const plr = game.add.existing new Player(game, x, y, color)
        if color is \black then core.black-player = plr
                           else core.white-player = plr
      platform: (x, y, w, h) ->
        core.platforms.add new Platform(game, x, y, w, h, color)
