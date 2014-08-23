{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

Phaser.Group.prototype.each = (func) ->
  let first = @cursor, next = @cursor
    return unless first
    func(first)
    while (next = @next!) isnt first
      func(next)

class @Platform extends Phaser.Group
  @create =
    black: (game, x, y, width, height) -> new Platform(game, x, y, width, height, \black)
    white: (game, x, y, width, height) -> new Platform(game, x, y, width, height, \white)

  (game, x, y, width, height, color) ->
    super game

    @color = color

    @enable-body = true
    @physics-body-type = Phaser.Physics.ARCADE

    @x = x; @y = y

    let (w = (width or 1), h = (height or 1),
      scale = (object, width, height) ->
        object
          ..scale
            ..x = width
            ..y = height
        )

      @inside = scale (@create 0 0 color), w, h

      @edges = []

      @edges << @top    = scale (@create  0, -2,  'empty'), w, 1
        ..alignment = \top
      @edges << @bottom = scale (@create  0, h+1, 'empty'), w, 1
        ..alignment = \bottom
      @edges << @left   = scale (@create -2,  0,  'empty'), 1, h
        ..alignment = \left
      @edges << @right  = scale (@create w+1, 0,  'empty'), 1, h
        ..alignment = \right

      @each (.body.immovable = true)

  debug: (game) ->
    @each game.debug~body
