{each, map, filter, lines, keys, values, abs, signum, join} = require 'prelude-ls'

class @Level.One extends Level
  init: ->
    level
      ..width 1200
      ..height 706

      ..platform
        ..black   0 258 1200 113
        ..black 801 572  339 111
        ..black 547 461  351 112
        ..black 547 367  168  96

      ..player
        ..black   64 117
        ..white 1128 595
