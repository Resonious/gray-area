{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

class @Level extends Phaser.Group
  (game) ->
    # game.clear-shit-out-or-make-sure-this-is-valid ?????

    super game

    @width = 800
    @height = 500

    @init!
    game.world.set-bounds @width, @height

  level:
    width: (@width =)
    height: (@height =)

    player:
      of-color: (color, x, y) -->
        raise "Already added #color player!" if this["added-#{color}-player"]
        @game.add[color].player x, y
        this["added-#{color}-player"] = true

      black: Level.level.player.of-color \black
      white: Level.level.player.of-color \white

    platform:
      of-color: (color, x, y, width, height) -->
        @add new Platform(@game, x, y, w, h, color)

      black: Level.level.platform.of-color \black
      white: Level.level.platform.of-color \white

  
  init: -> throw "plz implement me in subclasses"
