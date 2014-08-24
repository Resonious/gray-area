class @Level.One extends Level
  level-width: 1200
  level-height: 706

  init: (level) ->
    level
      ..platform
        ..black   0 258 1200 113
        ..black 801 572  339 111
        ..black 547 461  351 112
        ..black 547 367  168  96
        ..black 268 190  199  68
      
      ..player
        ..black   64 117
        ..white 1128 595

      ..gray 1115 255 128*1.5 128*1.5

      ..next-level Level.Two
