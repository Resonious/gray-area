class @Level.Five extends Level
  level-width: 1000
  level-height: 1000

  init: (level) ->
    level
      ..platform
        ..black 0 800 1000 90
        ..black 0 650 1000 90
        ..black 0 500 1000 90
        ..black 0 350 1000 90
        ..black 0 200 1000 90

        ..black 773 201 109 207 @mover  0   0   0 950  200
        ..black 530 202 109 207 @mover  0   0 200 1000 200
        ..black 295 203 109 207 @mover  0   0 100 900  200
        ..black  46 196 109 207 @mover 20 800 100 975  200
        ..black  15 782 218 189 @mover 50 900   8 1000 200

      ..danger 0 976 1000 24

      ..player
        ..black 450 50
        ..white 718 860

      ..gray 488 102 Level.ThankYou

  mover: (min-x, max-x, min-y, max-y, speed, platform) ~~>
    const body = platform.body

    process-y = ->
      if min-y is max-y then return
      if body.velocity.y is 0 then body.velocity.y = speed

      if body.y <= min-y
        body.velocity.y = speed
      else if body.y >= max-y
        body.velocity.y = -speed

    process-x = ->
      if min-x is max-x then return
      if body.velocity.x is 0 then body.velocity.x = speed

      if body.x <= min-x
        body.velocity.x = speed
      else if body.x >= max-x
        body.velocity.x = -speed

    process-x!
    process-y!
