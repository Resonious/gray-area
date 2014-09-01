class @Level.Test extends Level
  # level-width: 1000
  # level-height: 1000

  init: (level) ->
    level
      ..platform
        ..black  0 200 800 300 @upper
        ..white 50 150 500 200 @lower

      ..player
        ..black 200 100
        ..white 600 220

      ..gray 0 0 50 50 Level.Test

  upper: (platform) ->
    platform.inside.z = 10
    platform.custom-update = null

  lower: (platform) ->
    platform.inside.z = 5
    platform.custom-update = null
