class @Level.Test extends Level
  # level-width: 1000
  # level-height: 1000

  init: (level) ->
    level
      ..platform
        ..black 0 200 800 300

      ..player
        ..black 200 100
        ..white 220 220

      ..gray 0 0 50 50 Level.Test