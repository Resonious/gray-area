{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

towards = (current, target, amount) -->
  | current is target => return
  | otherwise =>
    increment = null
    passed    = null
    if current > target
      increment = (- amount)
      passed    = (<)
    else
      increment = (+ amount)
      passed    = (>)

    result = increment current
    if result `passed` target
      target
    else
      result

axis = (l, r) --> match l, r
  | true, false => -1
  | false, true =>  1
  | otherwise   =>  0

calculate-axis = (left-b, right-b) ->
  return 0 unless left-b and right-b
  axis left-b.is-down, right-b.is-down

class @Player extends Phaser.Sprite
  (game, x, y, color) ->
    super game, x, y, "player-#color"

    @color = color
    game.physics.arcade.enable this

    @anchor.set-to 0.5 0.5
    @body
      ..bounce.y  = 0.1
      ..bounce.x  = 0
      ..gravity.y = 2000
      ..collide-world-bounds = true
      ..set-size 22 57
    @animations
      ..add 'idle' [0]           0 true
      ..add 'walk' [0, 1, 2, 1]  13 true

      ..play 'idle'

  arrow-keys: null

  max-speed: 200
  acceleration: 50
  deceleration: 50

  target-direction: 0
  jump-timer: 0.0
  jump-timeout: 0.55
  jump-force: 500
  jump-boost-factor: 0.01
  jump-while-off-ground-time: 0.1
  air-timer: 0.0

  update: !->
    delta = @game.time.physics-elapsed
    keys = null
    axis = 0
    jump = 0
    if @arrow-keys and @arrow-keys!
      keys = @arrow-keys!
      axis = calculate-axis keys.left, keys.right
      jump = keys.up.is-down

    @target-direction = axis unless axis is 0

    @update-animation axis, delta
    @update-movement  axis, jump, delta

  update-animation: (axis, delta) !->
    direction = signum @body.velocity.x or 0
    
    target = @target-direction

    abs-is = (x, y) --> (abs y) is x

    match direction, axis
      | 0, 0 =>
        @animations.play 'idle'

      | (abs-is 1), (isnt direction) =>
        @scale.x := target
        @animations.play 'walk'

      | otherwise =>
        @scale.x := target unless target is 0
        @animations.play 'walk'

  update-movement: (axis, jump, delta) !->
    @body.velocity.x = 0 if @body.velocity.x |> isNaN

    if axis isnt 0
      passed = switch @target-direction
        | 1  => (>)
        | -1 => (<)
        | otherwise => -> false

      unless @body.velocity.x `passed` (@max-speed * @target-direction)
        @body.velocity.x += @acceleration * axis
    else
      towards-zero-by = @body.velocity.x `towards` 0
      @body.velocity.x = towards-zero-by @deceleration

    if @is-grounded!
      @air-timer = 0
    else
      @air-timer += delta

    if jump
      if @is-grounded! or @air-timer < @jump-while-off-ground-time
        @body.velocity.y = -@jump-force
        @jump-timer = 0.1

      else if @jump-timer isnt 0
        @body.velocity.y -= @jump-force * @jump-boost-factor

    if @jump-timer isnt 0
      @jump-timer += delta

    if @jump-timer >= @jump-timeout
      @jump-timer = 0

  is-grounded: -> @body.blocked.down or @body.touching.down
