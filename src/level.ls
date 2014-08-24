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
    throw "Next level required!" unless @next-level
  
  init: -> throw "plz implement me in subclasses"

level-methods = (context) ->
  context.level = 
    player:
      of-color: (color, x, y) ->
        if context.core.current-player color
          context.core.current-player color
            ..x = x
            ..y = y
            ..restore!
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

    danger: (x, y, w, h) ->
      context.game.add.danger x, y, w, h

    gray: (x, y, w, h) ->
      if context.gray then throw "Attempted to add 2 grays!"
      context.gray = context.add context.core.create-gray(x, y, w, h)

    next-level: (level) -> context.next-level = level