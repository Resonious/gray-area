{each, map, filter, lines, keys, values, abs, signum} = require 'prelude-ls'

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

class @Player extends Phaser.Sprite
  (game, x, y, color) ->
    super game, x, y, "player-#color"

    game.physics.arcade.enable this

    @anchor.set-to 0.5 0.5
    @body
      ..bounce.y  = 0.5
      ..bounce.x  = 0
      ..gravity.y = 150
      ..collide-world-bounds = true
      ..set-size 22 57 -1 2
    @animations
      ..add 'idle' [0]           0 true
      ..add 'walk' [0, 1, 2, 1]  13 true

      ..play 'walk'
