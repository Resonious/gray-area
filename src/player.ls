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

mul = (vec, scalar, target) --> target
  ..x = vec.x * scalar
  ..y = vec.y * scalar

class @Player extends Phaser.Sprite
  @wall-slide-factor = 0.2

  arrow-keys: null

  max-speed: 250
  acceleration: 50
  deceleration: 50

  target-direction: 1
  jump-timer: 0.0
  jump-timeout: 0.55
  jump-force: 500
  jump-boost-factor: 0.01
  jump-while-off-ground-time: 0.1
  air-timer: 0.0
  jumped: false

  was-grounded: false

  gravity: { x: 0, y: 2000 }
  wall-sliding: false
  wall-slide-x: null
  wall-slide-hit: null
  wall-jump-timer: 0.0

  current: false
  finished: false

  should-die: false

  (game, core, x, y, color) ->
    super game, x, y, "player-#color"

    @core = core
    @color = color
    game.physics.arcade.enable this

    @sound = {
      hit-ground: @game.add.audio 'hit-ground-1'
      jump: @game.add.audio 'jump'
      finish: @game.add.audio 'swap'
    }

    @anchor.set-to 0.5 0.5
    @body
      ..bounce.y  = 0.1
      ..bounce.x  = 0
      ..gravity.y = 2000
      ..collide-world-bounds = true
      ..set-size 22 57
    @do-animations!
      ..play 'idle'

  do-animations: ->
    @animations
      ..add 'idle'  [0] 0 true
      ..add 'walk'  [0, 1, 2, 1]  13 true
      ..add 'slide' [3] 0 true
      ..add 'jump'  [4] 0 true

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

    unless @finished
      @update-animation axis, delta
      @update-movement  axis, jump, delta

    if @please-restore
      @please-restore = false
      @restore!
    if @please-enable
      @please-enable = false
      @body.enable = true

  finish: !->
    return if @finished
    @finished = true

    const anim-name = @animations.current-anim.name
    const anim-frame = @animations.current-anim.frame

    @load-texture 'player-gray'
    @do-animations!
      ..play anim-name
      ..stop!
      ..frame = anim-frame

    @sound.finish.play '' 0 1 false
    @body.gravity.set-to 0 0
    @game.add.tween(@body.velocity)
      ..to {x: 0, y: 0}, 150, Phaser.Easing.Quadratic.InOut, true
      ..on-complete.add-once (-> @body.enable = false), this
      ..start!

  restore: !->
    return unless @finished
    @finished = false
    @body.enable = true

    @load-texture "player-#{@color}"
    @do-animations!
      ..play 'idle'

  update-animation: (axis, delta) !->
    direction = signum @body.velocity.x or 0
    
    target = @target-direction

    abs-is = (x, y) --> (abs y) is x

    if @wall-sliding
      @animations.play 'slide'
    else if @jumped
      @animations.play 'jump'
      @scale.x := -target
    else
      match direction, axis
        | 0, 0 =>
          @animations.play 'idle'

        | (abs-is 1), (isnt direction) =>
          @scale.x := target
          @animations.play 'walk'

        | otherwise =>
          @scale.x := target unless target is 0
          @animations.play 'walk'

  update-movement: (c-axis, jump, delta) !->
    @body.velocity.x = 0 if @body.velocity.x |> isNaN

    # ========= ARROW CONTROLS ============
    if @wall-jump-timer > 0
      @wall-jump-timer -= delta
    else if c-axis isnt 0
      passed = switch @target-direction
        | 1  => (>)
        | -1 => (<)
        | otherwise => -> false

      unless @body.velocity.x `passed` (@max-speed * @target-direction)
        @body.velocity.x += @acceleration * c-axis
    else
      towards-zero-by = @body.velocity.x `towards` 0
      @body.velocity.x = towards-zero-by @deceleration

    # ========== WALL SLIDING AND AIR TIMER =============
    const near-wall-slide-x = @body.x > @wall-slide-x - 1 and @body.x < @wall-slide-x + 1
    const hit-right = (@hit \right)
    const hit-left  = (@hit \left)
    const new-wall-sliding = (
        hit-right or hit-left or near-wall-slide-x) and not @is-grounded!

    if new-wall-sliding and not @wall-sliding
      @body.velocity.y = 0 if @body.velocity.y > 0
      @wall-slide-x = @body.x

    @wall-sliding = new-wall-sliding

    if @wall-jump-timer > 0
      mul @gravity, 0, @body.gravity
    
    if @wall-sliding
      @wall-slide-hit = if hit-right then -1 else if hit-left then 1 else -@target-direction
      mul @gravity, @@wall-slide-factor, @body.gravity if @body.velocity.y > 0
    else
      mul @gravity, 1, @body.gravity
      @wall-slide-x or= null

    if @is-grounded!
      unless @was-grounded
        @sound.hit-ground.play '' 0 1 false
        @was-grounded = true
      @air-timer = 0
    else
      @air-timer += delta
      @was-grounded = false if @air-timer > @jump-while-off-ground-time

    # ========== JUMPING ===========
    if jump
      if @wall-sliding and @air-timer > 0.15 and not @jumped
        # WALL JUMP!
        @body.velocity.y = -@jump-force * 1.5
        @body.velocity.x = @wall-slide-hit * @jump-force

        @target-direction = @wall-slide-hit
        @wall-jump-timer = 0.15

        @sound.jump.play '' 0 0.65 false

      else if @is-grounded! or @air-timer < @jump-while-off-ground-time
        # NORMAL JUMP!
        @body.velocity.y = -@jump-force
        @sound.jump.play '' 0 1 false if @jump-timer is 0
        @jump-timer = 0.1

      else if @jump-timer isnt 0
        # BOOST HEIGHT WHILST HOLDING JUMP BUTTON!
        @body.velocity.y -= @jump-force * @jump-boost-factor

    if @jump-timer isnt 0
      @jump-timer += delta

    if @jump-timer >= @jump-timeout
      @jump-timer = 0

    @jumped = jump

  is-grounded: -> @body.blocked.down or @body.touching.down

  hit: (side) ->
      @body.touching[side] || @body.blocked[side]
