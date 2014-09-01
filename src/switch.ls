{each, all, fold, foldr, filter, reject, map, empty, keys, values, abs, signum, join} = require 'prelude-ls'

class @Switch extends Phaser.Sprite
  was-touching-up: false
  touch-timer: 0

  (game, core, x, y, color) ->
    super game, x, y, "switch-#color"

    @core = core
    @color = color

    game.physics.arcade.enable this

    @anchor.set-to 0.5 0.5
    @body
      ..immovable = true
      ..set-size 28 3
      # ..gravity.y = 2000

    @animations
      ..add 'up'   [0] 0 true
      ..add 'down' [1] 0 true

  update: !->
    delta = @game.time.physics-elapsed

    if @touch-timer < 0
      if @body.touching.up and not @was-touching-up
        @was-touching-up = true
        @animations.play 'down'

        @on-press! if @on-press
        @touch-timer = 0.1

      if @was-touching-up and not @body.touching.up
        @was-touching-up = false
        @animations.play 'up'

        @on-release! if @on-release
        @touch-timer = 0.05

    else
      @touch-timer -= delta

    (@custom-update this) if @custom-update

  process-player-collide: (player) -> @color is player.color    
