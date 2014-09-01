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

dimension-from = (body) ->
  | body.overlap-x <= 0 and body.overlap-y <= 0 =>
      console.log "Man x is #{body.overlap-x} and y is #{body.overlap-y}"
  | body.overlap-x > body.overlap-y => \height
  | body.overlap-x <= body.overlap-y => \width
  | otherwise => \width

dimension-between = (bounds1, bounds2) ->
  const intersect = bounds1 `Phaser.Rectangle.intersection` bounds2
  match intersect
    | (-> it.width >= it.height) => \width
    | otherwise => \height

@PlatformCollision =
  collide: (physics, platforms, player) -->
    throw "Invalid physics #physics" unless physics
    player.overlapping = []

    platforms |> each (platform) ->
      physics.collide player, platform.inside, null,
        (PlatformCollision.process-inside-different player.color, platform)

    platforms |> each (platform) ->
      physics.collide player, platform.inside, null,
        (PlatformCollision.process-inside-same player.color, platform)

    platforms |> each (platform) ->
      physics.collide player, platform.edges, null,
        (PlatformCollision.process-edge player.color, platform)

  process-inside-different: (color, platform) ->
    | !color or !platform.color => throw "Something went wrong with platform/player color!"
    | color is platform.color   => -> false
    | otherwise =>
      (player, platform-inside) ->
        const intersect = Phaser.Rectangle.intersection
        player.overlapping.push {
          platform: platform
          intersection: (body-bounds player) `intersect` (body-bounds platform-inside)
        }
        false
  
  process-inside-same: (color, platform) ->
    | !color or !platform.color => throw "Something went wrong with platform/player color!"
    | color is platform.color   =>
      (player, platform-inside) ->
        const intersect     = Phaser.Rectangle.intersection
        const player-bounds = body-bounds player
        const intersection  = player-bounds `intersect` (body-bounds platform-inside)

        const player-area   = area player-bounds
        const check-rect = union-excluding null, player

        if (area intersection) > player-area * 0.9
          # If we are engulfed by the wall AND a background wall, we don't need to collide
          if (area check-rect) > player-area * 0.9
            return false
          # If we are engulfed only by a wall, we're dead
          else
            player.core.player-dead
            return true
        else
          const dimen = (body-bounds platform-inside) `dimension-between` player-bounds
          if check-rect[dimen] < player.body[dimen] - 0.5
            # If we're not engulfed by the wall, and there's no room to slide into a background,
            # We want to collide.
            return true
          else
            # If we're engulfed by the wall, but DO have room to slide into a background, we
            # don't want to collide
            return false

    | otherwise => -> false

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