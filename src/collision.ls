{each, all, fold, foldr, filter, reject, map, empty, keys, values, abs, signum, join} = require 'prelude-ls'

Phaser.Physics.Arcade.Body.prototype
  ..bounds = -> new Phaser.Rectangle(@x, @y, @width, @height)

body-bounds = (sprite) ->
  const b = sprite.body
  new Phaser.Rectangle(b.x, b.y, b.width, b.height)

unionify = (func) -> func (total, overlap) ->
  if Phaser.Rectangle.intersects overlap, total
    Phaser.Rectangle.union overlap, total
  else
    total

union-excluding = (platform, player) ->
  overlaps = player.overlapping 
    |> reject (.platform is platform)
    |> map (.intersection)
  
  return new Phaser.Rectangle(0,0,0,0) if empty overlaps

  rect = unionify(fold) overlaps.pop!, overlaps
  unionify(foldr) rect, overlaps

area = (rect) -> rect.width * rect.height

@PlatformCollision =
  collide: (physics, platforms, player) -->
    throw "Invalid physics #physics" unless physics
    player.overlapping = []

    platforms |> each (platform) ->
      physics.collide player, platform.inside, null,
        (PlatformCollision.process-inside player.color, platform)

    platforms |> each (platform) ->
      physics.collide player, platform.edges, null,
        (PlatformCollision.process-edge player.color, platform)

  process-inside: (color, platform) ->
    | !color or !platform.color => throw "Something went wrong with platform/player color!"
    | color is platform.color   =>
      (player, platform-inside) ->
        const intersect     = Phaser.Rectangle.intersection
        const player-bounds = body-bounds player
        const intersection  = player-bounds `intersect` (body-bounds platform-inside)
        player.core.player-dead! if (area intersection) > (area player-bounds) * 0.9
        true
    | otherwise =>
      (player, platform-inside) ->
        const intersect = Phaser.Rectangle.intersection
        player.overlapping.push {
          platform: platform
          intersection: (body-bounds player) `intersect` (body-bounds platform-inside)
        }
        false
  
  process-edge: (color, platform) ->
    | !color or !platform.color => throw "Something went wrong with platform/player color!"
    | color is platform.color   => null
    | otherwise =>
      (player, platform-edge) ->
        const dimen = platform-edge.relative-dimension
        const check-rect = union-excluding platform, player

        if check-rect[dimen] < player.body[dimen] - 2
          return true
        else # FIXME this bit is a little finnickey sometimes
          not Phaser.Rectangle.intersects (body-bounds platform-edge), check-rect
