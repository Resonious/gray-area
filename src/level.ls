{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

class @Level extends Phaser.Group
  platforms: []
  grays: []

  level-width: 800
  level-height: 500
  color: \white

  (game, core) ->
    super game

    @on-death = @constructor
    game.world.set-bounds 0, 0, @level-width, @level-height

    @core = core
    @current-layer = 0
    @init level-methods this
  
  init: -> throw "plz implement me in subclasses"

level-methods = (context) ->
  context.level = 
    player:
      of-color: (color, x, y) ->
        if context.core.current-player color
          context.core.current-player color
            ..x = x
            ..y = y
            ..please-restore = true
        else
          context.game.add[color].player x, y


      black: (...args) -> context.level.player.of-color \black, ...args
      white: (...args) -> context.level.player.of-color \white, ...args

    platform:
      of-color: (color, x, y, w, h, update-func) ->
        # console.log "Adding #color at #x, #y, #w, #h"
        const plat = context.game.add[color].platform x, y, w, h
        context.platforms.push plat
        plat
          ..custom-update = update-func
          ..layer = context.current-layer++

      black: (...args) -> context.level.platform.of-color \black, ...args
      white: (...args) -> context.level.platform.of-color \white, ...args

    text: (x, y, content, color) ->
      context.add new Phaser.Text(
        context.game, x, y, 
        content, { font: "45px Arial", fill: color or '#C0C0C0', align: "center" })

    switch:
      of-color: (color, x, y, config-func) ->
        const swit = context.game.add[color].switch x, y
        config-func swit if config-func

      black: (...args) -> context.level.switch.of-color \black, ...args
      white: (...args) -> context.level.switch.of-color \white, ...args

    danger: (x, y, w, h) ->
      context.game.add.danger x, y, w, h

    gray: (x, y, w, h, next-level) ->
      const width = if typeof w is 'number' then w else 256
      const height = if typeof h is 'number' then h else 256
      const level = if typeof w is 'number' then next-level else w
      context.grays.push context.add context.core.create-gray(x, y, width, height, level)

    background: (color) ->
      context.color = color
      context.background-color = switch color
        | \black => '#000000'
        | \gray  => '#CCCCCC'
        | otherwise => '#FFFFFF'
    
    on-death: (context.on-death =)
