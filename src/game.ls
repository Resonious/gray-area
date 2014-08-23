{each, map, filter, first, head, lines, keys, values} = require 'prelude-ls'

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

      ..spritesheet 'player-black' (asset 'gfx/player/black.png'), 84 84
      ..spritesheet 'player-white' (asset 'gfx/player/white.png'), 84 84
      # ..spritesheet 'player' (asset 'img/player/player.png'), 32 48
      # ..image 'sky' asset 'img/sky.png'
      # ..image 'ground' asset 'img/ground.png'

  create: !->
    custom-add-functions @game

    let (add     = @game.add, 
         physics = @game.physics, 
         world   = @game.world,
         camera  = @game.camera)

      @game.stage.background-color = '#FFFFFF'
      @game.time.advancedTiming = true

      physics.start-system Phaser.Physics.ARCADE

      # add.sprite 0 0 'sky'

      # @map = add.tilemap 'test-map'
        # ..add-tileset-image 'test-tiles'
        # ..set-collision 1, true

      # @map-layer = @map.create-layer 'First'
      #   ..resize-world!

      @platforms = add.group!
        ..add Platform.create.black @game, 135 500 516 74
          ..name = "Upper"
        ..add Platform.create.black @game, 20  550 700 100
          ..name = "Lower"

      @special-plat = @platforms.add Platform.create.black @game, 20 20 100 100
        ..name = "Special"

      @black-player = add.black.player 210 210
      @white-player = add.white.player 416 150

      # not racist
      camera.follow @black-player
      @current-color = \black

      @arrow-keys = @game.input.keyboard.create-cursor-keys!
      [@black-player, @white-player] |> each ~> it.arrow-keys = @get-player-keys it.color

      @switch-key = @game.input.keyboard.add-key(Phaser.Keyboard.TAB)
      @switch-key.on-down.add @switch-players


  update: !->
    # @player.update @arrow-keys, @game.time.physicsElapsed

    # # Protip: do collisions before messing with positions

    let collide = PlatformCollision.collide @game.physics.arcade, @platforms
      collide @black-player
      collide @white-player

    # DEBUG PLATFORM SSHITITTT
    let mouse = @game.input.mouse-pointer
      if @game.input.mouse-pointer.is-down 
        @game.physics.arcade.move-to-pointer @special-plat.inside, 200
      else
        @special-plat.body.velocity.set-to 0 0

  render: !->
    'ass'
    @platforms.each (platform) ~>
      platform.edges |> each @game.debug~body

  player-colors: <[black white]>

  switch-players: ~>
    @current-color = head filter ~>(it isnt @current-color), @player-colors
    @game.camera.follow(@["#{@current-color}-player"])

  get-player-keys: (color) -> 
    ~> if @current-color is color then @arrow-keys else null

custom-add-functions = (game) !->
  <[black white]> |> each (color) ->
    game.add[color] =
      player: (x, y) -> game.add.existing new Player(game, x, y, color)
      platform: (x, y, w, h) -> game.add.existing new Platform(game, x, y, w, h, color)