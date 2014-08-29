{signum, abs} = require 'prelude-ls'

class @Level.Four extends Level
  level-width: 1500
  level-height: 1200

  init: (level) ->
    level
      ..background \black

      ..platform
        ..white  515  739  187 131 @can-move
        ..white    0 1080 1500  33
        ..white  110  787   36 294
        ..white  265  895  330  31
        ..white 1418  588   82 493
        ..white    7  640  139 271
        ..white   39  515  433 158
        ..white 1144  899  189  31
        ..white  468  595  814  69
        ..white 1237  662   45  77

      ..text 275 779 ">\nSlowly..."

      ..danger 1426 615 74 305

      ..player
        ..black 602 787
        ..white 367 984

      ..gray 494 520 170 170 Level.Five

  can-move: (platform) ->
    platform.inside.body.immovable = false
    platform.inside.body.drag.x = 50
    platform.custom-update = null
