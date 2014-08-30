// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, map, filter, lines, keys, values, abs, signum, join, Level, levelMethods, slice$ = [].slice;
  ref$ = require('prelude-ls'), each = ref$.each, map = ref$.map, filter = ref$.filter, lines = ref$.lines, keys = ref$.keys, values = ref$.values, abs = ref$.abs, signum = ref$.signum, join = ref$.join;
  this.Level = Level = (function(superclass){
    var prototype = extend$((import$(Level, superclass).displayName = 'Level', Level), superclass).prototype, constructor = Level;
    prototype.platforms = [];
    prototype.grays = [];
    prototype.levelWidth = 800;
    prototype.levelHeight = 500;
    function Level(game, core){
      Level.superclass.call(this, game);
      this.onDeath = this.constructor;
      game.world.setBounds(0, 0, this.levelWidth, this.levelHeight);
      this.core = core;
      this.currentLayer = 0;
      this.init(levelMethods(this));
    }
    prototype.init = function(){
      throw "plz implement me in subclasses";
    };
    return Level;
  }(Phaser.Group));
  levelMethods = function(context){
    return context.level = {
      player: {
        ofColor: function(color, x, y){
          var x$;
          if (context.core.currentPlayer(color)) {
            x$ = context.core.currentPlayer(color);
            x$.x = x;
            x$.y = y;
            x$.pleaseRestore = true;
            return x$;
          } else {
            return context.game.add[color].player(x, y);
          }
        },
        black: function(){
          var args, ref$;
          args = slice$.call(arguments);
          return (ref$ = context.level.player).ofColor.apply(ref$, ['black'].concat(slice$.call(args)));
        },
        white: function(){
          var args, ref$;
          args = slice$.call(arguments);
          return (ref$ = context.level.player).ofColor.apply(ref$, ['white'].concat(slice$.call(args)));
        }
      },
      platform: {
        ofColor: function(color, x, y, w, h, updateFunc){
          var plat, x$;
          plat = context.game.add[color].platform(x, y, w, h);
          context.platforms.push(plat);
          x$ = plat;
          x$.customUpdate = updateFunc;
          x$.layer = context.currentLayer++;
          return x$;
        },
        black: function(){
          var args, ref$;
          args = slice$.call(arguments);
          return (ref$ = context.level.platform).ofColor.apply(ref$, ['black'].concat(slice$.call(args)));
        },
        white: function(){
          var args, ref$;
          args = slice$.call(arguments);
          return (ref$ = context.level.platform).ofColor.apply(ref$, ['white'].concat(slice$.call(args)));
        }
      },
      text: function(x, y, content, color){
        return context.add(new Phaser.Text(context.game, x, y, content, {
          font: "45px Arial",
          fill: color || '#C0C0C0',
          align: "center"
        }));
      },
      danger: function(x, y, w, h){
        return context.game.add.danger(x, y, w, h);
      },
      gray: function(x, y, w, h, nextLevel){
        var width, height, level;
        width = typeof w === 'number' ? w : 256;
        height = typeof h === 'number' ? h : 256;
        level = typeof w === 'number' ? nextLevel : w;
        return context.grays.push(context.add(context.core.createGray(x, y, width, height, level)));
      },
      background: function(color){
        return context.backgroundColor = (function(){
          switch (color) {
          case 'black':
            return '#000000';
          case 'gray':
            return '#CCCCCC';
          default:
            return '#FFFFFF';
          }
        }());
      },
      onDeath: (function(it){
        return context.onDeath = it;
      })
    };
  };
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
