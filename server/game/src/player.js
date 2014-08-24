// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, map, filter, lines, keys, values, abs, signum, join, towards, axis, calculateAxis, mul, Player;
  ref$ = require('prelude-ls'), each = ref$.each, map = ref$.map, filter = ref$.filter, lines = ref$.lines, keys = ref$.keys, values = ref$.values, abs = ref$.abs, signum = ref$.signum, join = ref$.join;
  towards = curry$(function(current, target, amount){
    var increment, passed, result;
    switch (false) {
    case current !== target:
      break;
    default:
      increment = null;
      passed = null;
      if (current > target) {
        increment = (function(it){
          return it - amount;
        });
        passed = curry$(function(x$, y$){
          return x$ < y$;
        });
      } else {
        increment = (function(it){
          return it + amount;
        });
        passed = curry$(function(x$, y$){
          return x$ > y$;
        });
      }
      result = increment(current);
      if (passed(result, target)) {
        return target;
      } else {
        return result;
      }
    }
  });
  axis = curry$(function(l, r){
    var ref$;
    switch (ref$ = [l, r], false) {
    case !(true === ref$[0] && false === ref$[1]):
      return -1;
    case !(false === ref$[0] && true === ref$[1]):
      return 1;
    default:
      return 0;
    }
  });
  calculateAxis = function(leftB, rightB){
    if (!(leftB && rightB)) {
      return 0;
    }
    return axis(leftB.isDown, rightB.isDown);
  };
  mul = curry$(function(vec, scalar, target){
    var x$;
    x$ = target;
    x$.x = vec.x * scalar;
    x$.y = vec.y * scalar;
    return x$;
  });
  this.Player = Player = (function(superclass){
    var prototype = extend$((import$(Player, superclass).displayName = 'Player', Player), superclass).prototype, constructor = Player;
    Player.wallSlideFactor = 0.2;
    prototype.arrowKeys = null;
    prototype.maxSpeed = 200;
    prototype.acceleration = 50;
    prototype.deceleration = 50;
    prototype.targetDirection = 1;
    prototype.jumpTimer = 0.0;
    prototype.jumpTimeout = 0.55;
    prototype.jumpForce = 500;
    prototype.jumpBoostFactor = 0.01;
    prototype.jumpWhileOffGroundTime = 0.1;
    prototype.airTimer = 0.0;
    prototype.jumped = false;
    prototype.wasGrounded = false;
    prototype.gravity = {
      x: 0,
      y: 2000
    };
    prototype.wallSliding = false;
    prototype.wallSlideX = null;
    prototype.wallSlideHit = null;
    prototype.wallJumpTimer = 0.0;
    prototype.current = false;
    prototype.finished = false;
    prototype.shouldDie = false;
    function Player(game, x, y, color){
      var x$, y$;
      Player.superclass.call(this, game, x, y, "player-" + color);
      this.color = color;
      game.physics.arcade.enable(this);
      this.sound = {
        hitGround: this.game.add.audio('hit-ground-1'),
        jump: this.game.add.audio('jump'),
        death: this.game.add.audio('death')
      };
      this.anchor.setTo(0.5, 0.5);
      x$ = this.body;
      x$.bounce.y = 0.1;
      x$.bounce.x = 0;
      x$.gravity.y = 2000;
      x$.collideWorldBounds = true;
      x$.setSize(22, 57);
      y$ = this.doAnimations();
      y$.play('idle');
    }
    prototype.doAnimations = function(){
      var x$;
      x$ = this.animations;
      x$.add('idle', [0], 0, true);
      x$.add('walk', [0, 1, 2, 1], 13, true);
      x$.add('slide', [3], 0, true);
      x$.add('jump', [4], 0, true);
      return x$;
    };
    prototype.update = function(){
      var delta, keys, axis, jump;
      delta = this.game.time.physicsElapsed;
      keys = null;
      axis = 0;
      jump = 0;
      if (this.arrowKeys && this.arrowKeys()) {
        keys = this.arrowKeys();
        axis = calculateAxis(keys.left, keys.right);
        jump = keys.up.isDown;
      }
      if (axis !== 0) {
        this.targetDirection = axis;
      }
      if (!this.finished) {
        this.updateAnimation(axis, delta);
        this.updateMovement(axis, jump, delta);
      }
    };
    prototype.finish = function(){
      var animName, animFrame, x$, y$;
      if (this.finished) {
        return;
      }
      this.finished = true;
      animName = this.animations.currentAnim.name;
      animFrame = this.animations.currentAnim.frame;
      this.loadTexture('player-gray');
      x$ = this.doAnimations();
      x$.play(animName);
      x$.stop();
      x$.frame = animFrame;
      this.body.gravity.setTo(0, 0);
      y$ = this.game.add.tween(this.body.velocity);
      y$.to({
        x: 0,
        y: 0
      }, 150, Phaser.Easing.Quadratic.InOut, true);
    };
    prototype.restore = function(){
      var x$;
      if (!this.finished) {
        return;
      }
      this.finished = false;
      this.loadTexture("player-" + this.color);
      x$ = this.doAnimations();
      x$.play('idle');
    };
    prototype.updateAnimation = function(axis, delta){
      var direction, target, absIs, ref$;
      direction = signum(this.body.velocity.x) || 0;
      target = this.targetDirection;
      absIs = curry$(function(x, y){
        return abs(y) === x;
      });
      if (this.wallSliding) {
        this.animations.play('slide');
      } else if (this.jumped) {
        this.animations.play('jump');
        this.scale.x = -target;
      } else {
        switch (ref$ = [direction, axis], false) {
        case !(0 === ref$[0] && 0 === ref$[1]):
          this.animations.play('idle');
          break;
        case !(absIs(1)(ref$[0]) && (function(it){
            return it !== direction;
          })(ref$[1])):
          this.scale.x = target;
          this.animations.play('walk');
          break;
        default:
          if (target !== 0) {
            this.scale.x = target;
          }
          this.animations.play('walk');
        }
      }
    };
    prototype.updateMovement = function(cAxis, jump, delta){
      var passed, towardsZeroBy, nearWallSlideX, hitRight, hitLeft, newWallSliding;
      if (isNaN(
      this.body.velocity.x)) {
        this.body.velocity.x = 0;
      }
      if (this.wallJumpTimer > 0) {
        this.wallJumpTimer -= delta;
      } else if (cAxis !== 0) {
        passed = (function(){
          switch (this.targetDirection) {
          case 1:
            return curry$(function(x$, y$){
              return x$ > y$;
            });
          case -1:
            return curry$(function(x$, y$){
              return x$ < y$;
            });
          default:
            return function(){
              return false;
            };
          }
        }.call(this));
        if (!passed(this.body.velocity.x, this.maxSpeed * this.targetDirection)) {
          this.body.velocity.x += this.acceleration * cAxis;
        }
      } else {
        towardsZeroBy = towards(this.body.velocity.x, 0);
        this.body.velocity.x = towardsZeroBy(this.deceleration);
      }
      nearWallSlideX = this.body.x > this.wallSlideX - 1 && this.body.x < this.wallSlideX + 1;
      hitRight = this.hit('right');
      hitLeft = this.hit('left');
      newWallSliding = (hitRight || hitLeft || nearWallSlideX) && !this.isGrounded();
      if (newWallSliding && !this.wallSliding) {
        if (this.body.velocity.y > 0) {
          this.body.velocity.y = 0;
        }
        this.wallSlideX = this.body.x;
      }
      this.wallSliding = newWallSliding;
      if (this.wallJumpTimer > 0) {
        mul(this.gravity, 0, this.body.gravity);
      }
      if (this.wallSliding) {
        this.wallSlideHit = hitRight
          ? -1
          : hitLeft
            ? 1
            : -this.targetDirection;
        if (this.body.velocity.y > 0) {
          mul(this.gravity, constructor.wallSlideFactor, this.body.gravity);
        }
      } else {
        mul(this.gravity, 1, this.body.gravity);
        this.wallSlideX || (this.wallSlideX = null);
      }
      if (this.isGrounded()) {
        if (!this.wasGrounded) {
          this.sound.hitGround.play('', 0, 1, false);
          this.wasGrounded = true;
        }
        this.airTimer = 0;
      } else {
        this.airTimer += delta;
        if (this.airTimer > this.jumpWhileOffGroundTime) {
          this.wasGrounded = false;
        }
      }
      if (jump) {
        if (this.wallSliding && this.airTimer > 0.15 && !this.jumped) {
          this.body.velocity.y = -this.jumpForce * 1.5;
          this.body.velocity.x = this.wallSlideHit * this.jumpForce;
          this.targetDirection = this.wallSlideHit;
          this.wallJumpTimer = 0.15;
          this.sound.jump.play('', 0, 1, false);
        } else if (this.isGrounded() || this.airTimer < this.jumpWhileOffGroundTime) {
          this.body.velocity.y = -this.jumpForce;
          if (this.jumpTimer === 0) {
            this.sound.jump.play('', 0, 1, false);
          }
          this.jumpTimer = 0.1;
        } else if (this.jumpTimer !== 0) {
          this.body.velocity.y -= this.jumpForce * this.jumpBoostFactor;
        }
      }
      if (this.jumpTimer !== 0) {
        this.jumpTimer += delta;
      }
      if (this.jumpTimer >= this.jumpTimeout) {
        this.jumpTimer = 0;
      }
      this.jumped = jump;
    };
    prototype.isGrounded = function(){
      return this.body.blocked.down || this.body.touching.down;
    };
    prototype.hit = function(side){
      return this.body.touching[side] || this.body.blocked[side];
    };
    return Player;
  }(Phaser.Sprite));
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
