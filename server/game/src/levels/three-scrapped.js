// Generated by LiveScript 1.2.0
(function(){
  var ThreeScrapped;
  this.Level.ThreeScrapped = ThreeScrapped = (function(superclass){
    var prototype = extend$((import$(ThreeScrapped, superclass).displayName = 'ThreeScrapped', ThreeScrapped), superclass).prototype, constructor = ThreeScrapped;
    prototype.levelWidth = 2000;
    prototype.levelHeight = 2000;
    prototype.init = function(level){
      var x$, y$;
      x$ = level;
      x$.background('black');
      y$ = x$.platform;
      y$.white(643, 1129, 524, 323);
      y$.white(65, 1450, 390, 176);
      y$.white(515, 1749, 505, 178);
      y$.white(1270, 1712, 529, 156);
      x$.danger(0, 1919, 2000, 81);
      return x$;
    };
    function ThreeScrapped(){
      ThreeScrapped.superclass.apply(this, arguments);
    }
    return ThreeScrapped;
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
