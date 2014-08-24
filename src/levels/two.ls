class @Level.Two extends Level
  level-width: 2000
  level-height: 2000

  init: (level) ->
    level
      ..platform
        ..black   0 367  745 986
        ..black   0   0   67 368
        ..black  66   0 1164 121

        ..white 183 976 297 222
        ..white 314 359 125 623

      ..player
        ..black 150  200
        ..white 170 1200

      ..gray 1500 700

      ..next-level Level.One