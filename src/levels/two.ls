class @Level.Two extends Level
  level-width: 2000
  level-height: 2000

  init: (level) ->
    level
      ..platform
        ..black    0 367  745 986
        ..black  474 119  163 251
        ..black   66   0 1164 121
        ..black 1267 364  445 159
        ..black 1227   0  707 184
        ..black 1824 182  110 704
        ..black 1562 784  271 144

        ..white 183 976 297 222
        ..white 478 976 268  73
        ..white 564 684  61 181
        ..white   0 527 746  55
        ..white 375 363  99 116

        ..black 744 883 328 231 @elevator

      ..danger 0 1919 2000 81

      ..player
        ..black 684  261
        ..white 170 1200

      ..gray 1522 783 Level.Three

      # ..on-death Level.One

  elevator: (platform) ~>
    @game.add.tween platform
      ..to {y: 117}, 10000, Phaser.Easing.Linear.None
      ..to {y: 883}, 10000, Phaser.Easing.Linear.None
      ..loop!
      ..start!

    platform.custom-update = null
