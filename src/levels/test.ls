class @Level.Test extends Level
  # level-width: 1000
  # level-height: 1000

  init: (level) ->
    level
      ..platform
        ..black 301 260 469 187
        ..black   0 347 305 100

      ..switch
        ..black 467 253 (@the-switch \black)
        ..white 409 440 (@the-switch \white)

      ..player
        ..black 200 100
        ..white 490 313

      ..gray 0 0 50 50 Level.Test

  the-switch: (color, self) -->
    self.on-press = ->
      const plr = if color is \black then 'whitePlayer' else 'blackPlayer'
      self.core[plr].body.velocity.y = -500
