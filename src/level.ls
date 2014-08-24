{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

class @Level extends Phaser.Group
  (game, width, height) ->
    @width = width
    @height = height

    @init!

  add:
    player:
      of-color: (color, position) ->
        throw "PLZ IMPLEMENT ME"

  init: -> throw "plz implement me in subclasses"
