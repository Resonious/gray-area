class @Level.ThreeScrapped extends Level
  level-width: 2000
  level-height: 2000

  init: (level) ->
    level
      ..background \black

      ..platform
        ..white  643 1129 524 323
        ..white   65 1450 390 176
        ..white  515 1749 505 178
        ..white 1270 1712 529 156


      ..danger 0 1919 2000 81