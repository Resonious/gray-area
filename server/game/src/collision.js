// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, all, fold, foldr, filter, reject, map, empty, keys, values, abs, signum, join, x$, bodyBounds, unionify, unionExcluding, area;
  ref$ = require('prelude-ls'), each = ref$.each, all = ref$.all, fold = ref$.fold, foldr = ref$.foldr, filter = ref$.filter, reject = ref$.reject, map = ref$.map, empty = ref$.empty, keys = ref$.keys, values = ref$.values, abs = ref$.abs, signum = ref$.signum, join = ref$.join;
  x$ = Phaser.Physics.Arcade.Body.prototype;
  x$.bounds = function(){
    return new Phaser.Rectangle(this.x, this.y, this.width, this.height);
  };
  bodyBounds = function(sprite){
    var b;
    b = sprite.body;
    return new Phaser.Rectangle(b.x, b.y, b.width, b.height);
  };
  unionify = function(func){
    return func(function(total, overlap){
      if (Phaser.Rectangle.intersects(overlap, total)) {
        return Phaser.Rectangle.union(overlap, total);
      } else {
        return total;
      }
    });
  };
  unionExcluding = function(platform, player){
    var overlaps, rect;
    overlaps = map(function(it){
      return it.intersection;
    })(
    reject(function(it){
      return it.platform === platform;
    })(
    player.overlapping));
    if (empty(overlaps)) {
      return new Phaser.Rectangle(0, 0, 0, 0);
    }
    rect = unionify(fold)(overlaps.pop(), overlaps);
    return unionify(foldr)(rect, overlaps);
  };
  area = function(rect){
    return rect.width * rect.height;
  };
  this.PlatformCollision = {
    collide: curry$(function(physics, platforms, player){
      if (!physics) {
        throw "Invalid physics " + physics;
      }
      player.overlapping = [];
      each(function(platform){
        return physics.collide(player, platform.inside, null, PlatformCollision.processInside(player.color, platform));
      })(
      platforms);
      return each(function(platform){
        return physics.collide(player, platform.edges, null, PlatformCollision.processEdge(player.color, platform));
      })(
      platforms);
    }),
    processInside: function(color, platform){
      switch (false) {
      case !(!color || !platform.color):
        throw "Something went wrong with platform/player color!";
      case color !== platform.color:
        return function(player, platformInside){
          var intersect, playerBounds, intersection;
          intersect = Phaser.Rectangle.intersection;
          playerBounds = bodyBounds(player);
          intersection = intersect(playerBounds, bodyBounds(platformInside));
          if (area(intersection) > area(playerBounds) * 0.8) {
            return player.core.playerDead();
          }
        };
      default:
        return function(player, platformInside){
          var intersect;
          intersect = Phaser.Rectangle.intersection;
          player.overlapping.push({
            platform: platform,
            intersection: intersect(bodyBounds(player), bodyBounds(platformInside))
          });
          return false;
        };
      }
    },
    processEdge: function(color, platform){
      switch (false) {
      case !(!color || !platform.color):
        throw "Something went wrong with platform/player color!";
      case color !== platform.color:
        return null;
      default:
        return function(player, platformEdge){
          var dimen, checkRect;
          dimen = platformEdge.relativeDimension;
          checkRect = unionExcluding(platform, player);
          if (checkRect[dimen] < player.body[dimen] - 2) {
            return true;
          } else {
            return !Phaser.Rectangle.intersects(bodyBounds(platformEdge), checkRect);
          }
        };
      }
    }
  };
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
