// Generated by LiveScript 1.2.0
(function(){
  var ThankYou;
  this.Level.ThankYou = ThankYou = (function(superclass){
    var prototype = extend$((import$(ThankYou, superclass).displayName = 'ThankYou', ThankYou), superclass).prototype, constructor = ThankYou;
    prototype.levelWidth = 800;
    prototype.levelHeight = 500;
    prototype.init = function(level){
      var x$, y$;
      x$ = level;
      x$.background('gray');
      x$.text(200, 200, "Thanks for playing!", '#4D4D4D');
      y$ = x$.player;
      y$.black(200, 100);
      y$.white(500, 100);
      return x$;
    };
    function ThankYou(){
      ThankYou.superclass.apply(this, arguments);
    }
    return ThankYou;
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
