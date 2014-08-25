class @Level.ThankYou extends Level
  level-width: 800
  level-height: 500

  init: (level) ->
    level
      ..background \gray

      ..text 200 200 "Thanks for playing!", '#4D4D4D'

      ..player
        ..black 200, 100
        ..white 500, 100
