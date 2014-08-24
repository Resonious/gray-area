class @Level.Three extends Level
  level-width: 1500
  level-height: 1500

  init: (level) ->
    level
      ..platform
        ..black    0 285 861   78
        ..black    0   0 291 1500
        ..black  507 159 100  403 @can-move
        ..black  951 283 259  197
        ..black 1127 480  84  349
        ..black  625 915 875   91
        ..black 1086 725 414   94 @can-move
        ..black 1301 499 199   82

      ..text 1248 587 "'R'\nto retry"
      ..text 402 192 '>'
      ..text 1238 525 'v'

      ..danger 793 432 195 48
      ..danger 0 1419 1500 81

      ..player
        ..black 376 199
        ..white 534 461

      ..gray 664 910 185 185 Level.Four

  can-move: (platform) ->
    platform.inside.body.immovable = false
    platform.custom-update = null