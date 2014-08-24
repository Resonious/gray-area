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

      @top    = scale (@create  0, -2,  'empty'), w, 1
        ..part = \top
        ..relative-dimension = 'width'
        ..body.check-collision.up = false
        ..body.check-collision.left = false
        ..body.check-collision.right = false
      @bottom = scale (@create  0, h+1, 'empty'), w, 1
        ..part = \bottom
        ..relative-dimension = 'width'
        ..body.check-collision.down = false
        ..body.check-collision.left = false
        ..body.check-collision.right = false
      @left   = scale (@create -2,  0,  'empty'), 1, h
        ..part = \left
        ..relative-dimension = 'height'
        ..body.check-collision.left = false
        ..body.check-collision.up = false
        ..body.check-collision.down = false
      @right  = scale (@create w+1, 0,  'empty'), 1, h
        ..part = \right
        ..relative-dimension = 'height'
        ..body.check-collision.right = false
        ..body.check-collision.up = false
        ..body.check-collision.down = false

      @edges = [@top, @bottom, @left, @right]
      @each (.body.immovable = true)

      @body = @inside.body

  update: !->
    @edges |> each ~> it.body.velocity = @inside.body.velocity
    @custom-update(this) if @custom-update

  debug: (game) !->
    @each game.debug~body
