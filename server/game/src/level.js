// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, map, filter, lines, keys, values, abs, signum, join, Level;
  ref$ = require('prelude-ls'), each = ref$.each, map = ref$.map, filter = ref$.filter, lines = ref$.lines, keys = ref$.keys, values = ref$.values, abs = ref$.abs, signum = ref$.signum, join = ref$.join;
  this.Level = Level = (function(superclass){
    var prototype = extend$((import$(Level, superclass).displayName = 'Level', Level), superclass).prototype, constructor = Level;
    function Level(game){
      Level.superclass.call(this, game);
      this.width = 800;
      this.height = 500;
      this.init();
      game.world.setBounds(this.width, this.height);
    }
    prototype.level = {
      width: (function(it){
        return this.width = it;
      }),
      height: (function(it){
        return this.height = it;
      }),
      player: {
        ofColor: curry$(function(color, x, y){
          if (this["added-" + color + "-player"]) {
            raise("Already added " + color + " player!");
          }
          this.game.add[color].player(x, y);
          return this["added-" + color + "-player"] = true;
        }),
        black: Level.level.player.ofColor('black'),
        white: Level.level.player.ofColor('white')
      },
      platform: {
        ofColor: curry$(function(color, x, y, width, height){
          return this.add(new Platform(this.game, x, y, w, h, color));
        }),
        black: Level.level.platform.ofColor('black'),
        white: Level.level.platform.ofColor('white')
      }
    };
    prototype.init = function(){
      throw "plz implement me in subclasses";
    };
    return Level;
  }(Phaser.Group));
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
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);