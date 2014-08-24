{each, all, map, filter, first, head, lines, keys, values, head} = require 'prelude-ls'

mul = (vec, scalar) -->
  new Phaser.Point(vec.x * scalar, vec.y * scalar)

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
      ..image 'red'   asset 'gfx/tiles/red.png'
      ..image 'empty' asset 'gfx/tiles/empty.png'
      ..image 'gray'  asset 'gfx/tiles/gray.png'

      ..image 'indicator' asset 'gfx/ui/indicator.png'
      ..image 'locator' asset 'gfx/ui/locator.png'

      ..audio 'hit-ground-1' asset 'sfx/hit-ground-1.ogg'
      ..audio 'jump' asset 'sfx/jump.ogg'
      ..audio 'death' asset 'sfx/death.ogg'
      ..audio 'swap' asset 'sfx/swap.ogg'
      ..audio 'cant-swap' asset 'sfx/cant-swap.ogg'
      ..audio 'level-complete' asset 'sfx/level-complete.ogg'
      ..audio 'reset' asset '/sfx/reset.ogg'

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

      @swap-sound = add.audio 'swap'
      @cant-swap-sound = add.audio 'cant-swap'
      @level-complete-sound = add.audio 'level-complete'
      @death-sound = add.audio 'death'
      @reset-sound = add.audio 'reset'

      @arrow-keys = @game.input.keyboard.create-cursor-keys!

      each (~> @game.input.keyboard.add-key(it).on-down.add @switch-players),
           [Phaser.Keyboard.TAB, Phaser.Keyboard.CONTROL]

      @game.input.keyboard.add-key Phaser.Keyboard.R
        ..on-down.add ~>
          @reset-sound.play '' 0 1 false
          @load-level @current-level.constructor

      @locator = @game.add.sprite -100, -100 'locator'
        ..anchor.set-to 0.5 0.5

      @platforms = add.group!
      @dangers   = add.group!
      @load-level Level.Three

  load-level: (level) !->
    if @current-level
      @dangers.remove-all true
      @platforms.remove-all true
      @current-level.destroy!

    @current-level = @game.add.existing new level(@game, this)

    @black-player.bring-to-top!
    @white-player.bring-to-top!
    @locator.bring-to-top!

    [@black-player, @white-player] |> each ~> it.arrow-keys = @get-player-keys it.color

    # @game.camera.follow @black-player
    @current-color = \black
    @black-player.current = true
    @white-player.current = false

    @do-gui!

  do-gui: !->
    @gui.destroy! if @gui
    @gui = @game.add.group!
      ..fixed-to-camera = true
    @indicator = @gui.create 700 100 'indicator'
      ..anchor.set-to 0.5 0.5
      ..angle = 180

  update: !->
    let collide = PlatformCollision.collide @game.physics.arcade, @current-level.platforms
      collide @black-player if @black-player
      collide @white-player if @white-player

    let arcade = @game.physics.arcade
      arcade.collide @black-player, @dangers, @player-dead if @black-player
      arcade.collide @white-player, @dangers, @player-dead if @white-player

    [@black-player, @white-player] |> each (player) ~>
      @game.physics.arcade.collide player, @current-level.grays, null, @finish-player

    let player = @current-player!
      if player
        @locator.x = player.x
        @locator.y = player.y - player.body.height

    @move-camera!

    # DEBUG PLATFORM SSHITITTT
    # let mouse = @game.input.mouse-pointer
    #   if @game.input.mouse-pointer.is-down 
    #     @game.physics.arcade.move-to-pointer @special-plat.inside, 200
    #   else
    #     @special-plat.body.velocity.set-to 0 0

  render: !->
    'ass'
    # @game.debug.body @current-level.gray
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

  move-camera: ->
    const player = @current-player!
    const cam-point = new Phaser.Point(
      @game.camera.x + @game.camera.width/2, @game.camera.y + @game.camera.height/2
    )
    const player-point = new Phaser.Point(player.body.x, player.body.y)

    const target = Phaser.Point.interpolate cam-point, player-point, 0.08

    @game.camera
      ..x = target.x - @game.camera.width/2
      ..y = target.y - @game.camera.height/2

  finish-player: (player, gray) ~>
    return false if player.finished
    player.finish!

    if [@black-player, @white-player] |> all (.finished)
      @level-complete-sound.play '' 0 1 false
      @game.add.tween(gray.scale)
        ..to { x: 10, y: 10 }, 1000, Phaser.Easing.Quadratic.In, true
        ..on-complete.add-once (@fade-to-level gray.next-level), this
        ..start!
    else
      @switch-players! if player.current
    false

  fade-to-level: (level) ->
    -> @load-level level or @current-level.on-death

  player-dead: ~>
    @death-sound.play '' 0 1 false
    @load-level @current-level.on-death

  current-player: (color) ~> switch color or @current-color
    | \black => @black-player
    | \white => @white-player

  player-colors: <[black white]>
  switch-players: ~>
    const other-color = head filter ~>(it isnt @current-color), @player-colors
    if (@current-player other-color).finished
      @cant-swap-sound.play '' 0 0.5 false
      return

    @current-player!.current = false
    @current-color = other-color
    @current-player!.current = true
    # @game.camera.follow(@current-player!)

    const target = if @current-color is \black then 180 else 0
    @game.add.tween(@indicator)
      ..to {angle: target}, 1000, Phaser.Easing.Quadratic.InOut, true

    @swap-sound.play '' 0 1 false

  get-player-keys: (color) -> 
    ~> if @current-color is color then @arrow-keys else null

  create-gray: (x, y, width = 256, height = 256, next-level) ->
    throw "Next level required!" unless next-level

    const gray = new Phaser.Sprite(@game, 0, 0, 'gray')
    @game.physics.arcade.enable gray
    gray
      ..next-level = next-level
      ..anchor.set-to 0.5 0.5
      ..width  = width
      ..height = height
      ..x = x
      ..y = y
      ..body
        ..set-size width * 0.9, height * 0.9

custom-add-functions = (game, core) !->
  <[black white]> |> each (color) ->
    game.add[color] =
      player: (x, y) ->
        const plr = game.add.existing new Player(game, core, x, y, color)
        if color is \black then core.black-player = plr
                           else core.white-player = plr
      platform: (x, y, w, h) ->
        core.platforms.add new Platform(game, x, y, w, h, color)

    game.add.danger = (x, y, w, h) ->
      const dang = core.dangers.add new Phaser.Sprite(game, x, y, 'red')
      game.physics.arcade.enable dang
      dang
        ..width = w
        ..height = h
