{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

@PlatformCollision =
  collide: (physics, platforms, player) -->
    player.overlapping-platforms = []

    platforms.each (platform) ->
      physics.collide player, platform.inside, null,
                      (PlatformCollision.process-inside player.color, platform)
      physics.collide player, platform.edges, null,
                      (PlatformCollision.process-edge player.color, platform)

  process-inside: (color, platform) ->
    | !color or !platform.color => throw "Something went wrong with platform color!"
    | color is platform.color   => null
    | otherwise =>
      (player, platform-body) ->
        player.overlapping-platforms.push platform
        false

  process-edge: (color, platform) ->
    | !color or !platform.color => throw "Something went wrong with platform color!"
    | color is platform.color   => null
    | otherwise =>
      (player, platform-edge) ->
        true # for now
