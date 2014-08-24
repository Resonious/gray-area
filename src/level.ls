{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

class @Level extends Phaser.Group
  platforms: []
  level-width: 800
  level-height: 500

  (game, core) ->
    super game

    game.world.set-bounds 0, 0, @level-width, @level-height

    @core = core
    @init level-methods this
  
  init: -> throw "plz implement me in subclasses"

level-methods = (context) ->
  context.level = 
    player:
      of-color: (color, x, y) ->
        if context.core["#{color}-player"]
          context.core["#{color}-player"]
            ..x = x
            ..y = y
            ..revive!
        else
          context.game.add[color].player x, y


      black: (...args) -> context.level.player.of-color \black, ...args
      white: (...args) -> context.level.player.of-color \white, ...args

    platform:
      of-color: (color, x, y, w, h) ->
        # console.log "Adding #color at #x, #y, #w, #h"
        const plat = context.game.add[color].platform x, y, w, h
        context.platforms.push plat
        plat

      black: (...args) -> context.level.platform.of-color \black, ...args
      white: (...args) -> context.level.platform.of-color \white, ...args
