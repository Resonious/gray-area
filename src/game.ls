{each, map, filter, lines, keys, values} = require 'prelude-ls'

class @GameCore
  (game) !->
    @game = game

  preload: !->
    asset = (p) -> "game/assets/#p"
    @game.load
      ..tilemap 'test-map' (asset 'maps/test-map.json'), null, Phaser.Tilemap.TILED_JSON
      ..image 'test-tiles' asset 'gfx/tiles/black-and-white.png'
      ..spritesheet 'player-black' (asset 'gfx/player/black.png'), 84 84
      ..spritesheet 'player-white' (asset 'gfx/player/white.png'), 84 84
      # ..spritesheet 'player' (asset 'img/player/player.png'), 32 48
      # ..image 'sky' asset 'img/sky.png'
      # ..image 'ground' asset 'img/ground.png'

  create: !->
    let (add     = @game.add, 
         physics = @game.physics, 
         world   = @game.world,
         camera  = @game.camera)

      console.log 'lmfao!!!!'

      @game.time.advancedTiming = true

      physics.start-system Phaser.Physics.ARCADE

      # add.sprite 0 0 'sky'

      @map = add.tilemap 'test-map'
        ..add-tileset-image 'test-tiles'
        ..set-collision 1, true

      @map-layer = @map.create-layer 'First'
        ..resize-world!

      # @player = new Player(@game, 100, world.height - 200)

      @player = new Player(@game, 210, 210, 'black')
      add.existing @player
      camera.follow @player

      @arrow-keys = @game.input.keyboard.create-cursor-keys!
      @player.arrow-keys = ~> @arrow-keys

      # @platforms = add.group!
      #   ..enable-body = true

      # ground = @platforms.create 0, world.height - 64, 'ground'
      #   ..scale.set-to 2, 2
      #   ..body.immovable = true

      # ledge = @platforms.create 400, 100, 'ground'
      #   ..body.immovable = true
      # ledge2 = @platforms.create -150, 250, 'ground'
      #   ..body.immovable = true

  update: !->
    # @player.update @arrow-keys, @game.time.physicsElapsed

    # # Protip: do collisions before messing with positions
    @game.physics.arcade
      ..collide @player, @map-layer

  render: !->
    @game.debug.body(@player);
