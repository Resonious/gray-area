// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, map, filter, lines, keys, values, abs, signum, join, One;
  ref$ = require('prelude-ls'), each = ref$.each, map = ref$.map, filter = ref$.filter, lines = ref$.lines, keys = ref$.keys, values = ref$.values, abs = ref$.abs, signum = ref$.signum, join = ref$.join;
  this.Level.One = One = (function(superclass){
    var prototype = extend$((import$(One, superclass).displayName = 'One', One), superclass).prototype, constructor = One;
    prototype.levelWidth = 1200;
    prototype.levelHeight = 706;
    prototype.init = function(level){
      var x$, y$, z$;
      x$ = level;
      y$ = x$.platform;
      y$.black(0, 258, 1200, 113);
      y$.black(801, 572, 339, 111);
      y$.black(547, 461, 351, 112);
      y$.black(547, 367, 168, 96);
      z$ = x$.player;
      z$.black(64, 117);
      z$.white(1128, 595);
      x$.gray(1115, 255, 128 * 1.5, 128 * 1.5);
      return x$;
    };
    function One(){
      One.superclass.apply(this, arguments);
    }
    return One;
  }(Level));
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
