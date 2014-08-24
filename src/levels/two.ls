class @Level.Two extends Level
  level-width: 2000
  level-height: 2000

  init: (level) ->
    level
      ..platform
        ..black    0 367  745 986
        ..black    0   0   67 368
        ..black   66   0 1164 121
        ..black 1267 364  445 159
        ..black 1227 0    707 184
        ..black 1548 170  164 201

        ..white 183 976 297 222
        ..white 478 976 268  73
        ..white 564 684  61 181
        ..white   0 527 746  55

        ..black 744 883 328 231 @elevator

      ..danger 0 1919 2000 81

      ..player
        ..black 150  200
        ..white 170 1200

      ..gray 1500 700 Level.One

      # ..on-death Level.One

  elevator: (platform) ~>
    @game.add.tween platform
      ..to {y: 117}, 10000, Phaser.Easing.Linear.None
      ..to {y: 883}, 10000, Phaser.Easing.Linear.None
      ..loop!
      ..start!

    platform.custom-update = null
