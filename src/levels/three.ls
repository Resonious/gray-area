class @Level.Three extends Level
  level-width: 1500
  level-height: 1500

  init: (level) ->
    level
      ..platform
        ..black    0 285 861  78
        ..black    0   0 291 289
        ..black  507 159 100 403 @moves-on-axis \x
        ..black  951 283 259 197
        ..black 1127 480  84 349
        ..black  625 915 875  91
        ..black 1086 725 414  94 @moves-on-axis \y

      ..danger 793 432 195 48
      ..danger 0 1419 1500 81

      ..player
        ..black 376 199
        ..white 534 461

      ..gray 664 910 Level.One

  moves-on-axis: (axis, platform) ~~>
    const other-axis = switch axis
      | \y => \x
      | \x => \y
    platform.inside.body
      ..immovable = false
      ..max-velocity[other-axis] = 0
      ..max-velocity[axis] = 150

    platform.custom-update = null
