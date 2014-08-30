// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, all, map, filter, first, head, lines, keys, values, mul, GameCore, customAddFunctions;
  ref$ = require('prelude-ls'), each = ref$.each, all = ref$.all, map = ref$.map, filter = ref$.filter, first = ref$.first, head = ref$.head, lines = ref$.lines, keys = ref$.keys, values = ref$.values, head = ref$.head;
  mul = curry$(function(vec, scalar){
    return new Phaser.Point(vec.x * scalar, vec.y * scalar);
  });
  this.GameCore = GameCore = (function(){
    GameCore.displayName = 'GameCore';
    var prototype = GameCore.prototype, constructor = GameCore;
    function GameCore(game){
      this.toggleSound = bind$(this, 'toggleSound', prototype);
      this.switchPlayers = bind$(this, 'switchPlayers', prototype);
      this.currentPlayer = bind$(this, 'currentPlayer', prototype);
      this.playerDead = bind$(this, 'playerDead', prototype);
      this.finishPlayer = bind$(this, 'finishPlayer', prototype);
      this.game = game;
    }
    prototype.preload = function(){
      var asset, x$;
      asset = function(p){
        return "game/assets/" + p;
      };
      x$ = this.game.load;
      x$.image('black', asset('gfx/tiles/black.png'));
      x$.image('white', asset('gfx/tiles/white.png'));
      x$.image('red', asset('gfx/tiles/red.png'));
      x$.image('empty', asset('gfx/tiles/empty.png'));
      x$.image('gray', asset('gfx/tiles/gray.png'));
      x$.image('indicator', asset('gfx/ui/indicator.png'));
      x$.image('locator', asset('gfx/ui/locator.png'));
      x$.image('sound', asset('gfx/ui/sound.png'));
      x$.image('no-sound', asset('gfx/ui/no-sound.png'));
      x$.audio('hit-ground-1', asset('sfx/hit-ground-1.ogg'));
      x$.audio('jump', asset('sfx/jump.ogg'));
      x$.audio('death', asset('sfx/death.ogg'));
      x$.audio('swap', asset('sfx/swap.ogg'));
      x$.audio('cant-swap', asset('sfx/cant-swap.ogg'));
      x$.audio('level-complete', asset('sfx/level-complete.ogg'));
      x$.audio('reset', asset('/sfx/reset.ogg'));
      x$.audio('bgm', asset('music/gray.ogg'));
      x$.spritesheet('player-black', asset('gfx/player/black.png'), 84, 84);
      x$.spritesheet('player-white', asset('gfx/player/white.png'), 84, 84);
      x$.spritesheet('player-gray', asset('gfx/player/gray.png'), 84, 84);
    };
    prototype.create = function(){
      customAddFunctions(this.game, this);
      (function(add, physics, world, camera){
        var x$, y$, z$, this$ = this;
        x$ = this.bgm = add.audio('bgm');
        x$.play('', 0, 0.5, true);
        this.game.stage.backgroundColor = '#FFFFFF';
        this.game.time.advancedTiming = true;
        physics.startSystem(Phaser.Physics.ARCADE);
        this.swapSound = add.audio('swap');
        this.cantSwapSound = add.audio('cant-swap');
        this.levelCompleteSound = add.audio('level-complete');
        this.deathSound = add.audio('death');
        this.resetSound = add.audio('reset');
        this.arrowKeys = this.game.input.keyboard.createCursorKeys();
        each(function(it){
          return this$.game.input.keyboard.addKey(it).onDown.add(this$.switchPlayers);
        }, [Phaser.Keyboard.TAB, Phaser.Keyboard.CONTROL]);
        y$ = this.game.input.keyboard.addKey(Phaser.Keyboard.R);
        y$.onDown.add(function(){
          this$.resetSound.play('', 0, 1, false);
          return this$.loadLevel(this$.currentLevel.constructor);
        });
        z$ = this.locator = this.game.add.sprite(-100, -100, 'locator');
        z$.anchor.setTo(0.5, 0.5);
        this.platforms = add.group();
        this.dangers = add.group();
        this.loadLevel(Level.Test);
      }.call(this, this.game.add, this.game.physics, this.game.world, this.game.camera));
    };
    prototype.loadLevel = function(level){
      var err, this$ = this;
      if (this.currentLevel) {
        this.dangers.removeAll(true);
        this.platforms.removeAll(true);
        this.currentLevel.destroy();
        each(function(it){
          return it.body.enable = false;
        })(
        [this.whitePlayer, this.blackPlayer]);
      }
      try {
        this.currentLevel = this.game.add.existing(new level(this.game, this));
      } catch (e$) {
        err = e$;
        throw "Either there were errors in the level, or you forgot to add it to index.html";
      }
      this.game.stage.backgroundColor = this.currentLevel.backgroundColor || '#FFFFFF';
      this.blackPlayer.bringToTop();
      this.whitePlayer.bringToTop();
      this.locator.bringToTop();
      each(function(it){
        it.arrowKeys = this$.getPlayerKeys(it.color);
        return it.pleaseEnable = true;
      })(
      [this.blackPlayer, this.whitePlayer]);
      this.currentColor = 'black';
      this.blackPlayer.current = true;
      this.whitePlayer.current = false;
      this.doGui();
    };
    prototype.doGui = function(){
      var x$, y$;
      if (this.gui) {
        this.gui.destroy();
      }
      x$ = this.gui = this.game.add.group();
      x$.fixedToCamera = true;
      y$ = this.indicator = this.gui.create(700, 100, 'indicator');
      y$.anchor.setTo(0.5, 0.5);
      y$.angle = 180;
      this.soundToggle = this.gui.add(new Phaser.Button(this.game, 750, 18, 'sound', this.toggleSound));
      if (this.game.sound.mute) {
        this.soundToggle.loadTexture('no-sound');
      }
    };
    prototype.update = function(){
      var this$ = this;
      (function(collide){
        if (this.blackPlayer) {
          collide(this.blackPlayer);
        }
        if (this.whitePlayer) {
          collide(this.whitePlayer);
        }
      }.call(this, PlatformCollision.collide(this.game.physics.arcade, this.currentLevel.platforms)));
      (function(arcade){
        if (this.blackPlayer) {
          arcade.collide(this.blackPlayer, this.dangers, this.playerDead);
        }
        if (this.whitePlayer) {
          arcade.collide(this.whitePlayer, this.dangers, this.playerDead);
        }
      }.call(this, this.game.physics.arcade));
      each(function(player){
        return this$.game.physics.arcade.collide(player, this$.currentLevel.grays, null, this$.finishPlayer);
      })(
      [this.blackPlayer, this.whitePlayer]);
      (function(player){
        if (player) {
          this.locator.x = player.x;
          this.locator.y = player.y - player.body.height;
        }
      }.call(this, this.currentPlayer()));
      this.moveCamera();
    };
    prototype.render = function(){
      'ass';
    };
    prototype.debugLog = function(){
      var key, value, this$ = this;
      console.log((function(){
        var results$ = [];
        for (key in this) {
          value = this[key];
          results$.push(key + ": " + value);
        }
        return results$;
      }.call(this)));
      console.log("====== PLATFORMS ========");
      console.log(this.currentLevel.platforms);
      each(function(platform){
        return console.log(platform.color + " " + platform.x + ", " + platform.y);
      })(
      this.currentLevel.platforms);
      console.log("====== CAMERA =======");
      console.log(this.game.camera.x + ", " + this.game.camera.y);
      return '=========== done ===========';
    };
    prototype.moveCamera = function(){
      var player, camPoint, playerPoint, target, x$;
      player = this.currentPlayer();
      camPoint = new Phaser.Point(this.game.camera.x + this.game.camera.width / 2, this.game.camera.y + this.game.camera.height / 2);
      playerPoint = new Phaser.Point(player.body.x, player.body.y);
      target = Phaser.Point.interpolate(camPoint, playerPoint, 0.08);
      x$ = this.game.camera;
      x$.x = target.x - this.game.camera.width / 2;
      x$.y = target.y - this.game.camera.height / 2;
      return x$;
    };
    prototype.finishPlayer = function(player, gray){
      var x$;
      if (player.finished) {
        return false;
      }
      player.finish();
      if (all(function(it){
        return it.finished;
      })(
      [this.blackPlayer, this.whitePlayer])) {
        this.levelCompleteSound.play('', 0, 1, false);
        x$ = this.game.add.tween(gray.scale);
        x$.to({
          x: 10,
          y: 10
        }, 1000, Phaser.Easing.Quadratic.In, true);
        x$.onComplete.addOnce(this.fadeToLevel(gray.nextLevel), this);
        x$.start();
      } else {
        if (player.current) {
          this.switchTimeout = setTimeout(bind$(this, 'switchPlayers'), 600);
        }
      }
      return false;
    };
    prototype.fadeToLevel = function(level){
      return function(){
        return this.loadLevel(level) || this.currentLevel.onDeath;
      };
    };
    prototype.playerDead = function(){
      this.deathSound.play('', 0, 0.7, false);
      return this.loadLevel(this.currentLevel.onDeath);
    };
    prototype.currentPlayer = function(color){
      switch (color || this.currentColor) {
      case 'black':
        return this.blackPlayer;
      case 'white':
        return this.whitePlayer;
      }
    };
    prototype.playerColors = ['black', 'white'];
    prototype.switchPlayers = function(){
      var otherColor, target, x$, this$ = this;
      if (this.switchTimeout) {
        clearTimeout(this.switchTimeout);
      }
      otherColor = head(filter(function(it){
        return it !== this$.currentColor;
      }, this.playerColors));
      if (this.currentPlayer(otherColor).finished) {
        this.cantSwapSound.play('', 0, 0.5, false);
        return;
      }
      this.currentPlayer().current = false;
      this.currentColor = otherColor;
      this.currentPlayer().current = true;
      target = this.currentColor === 'black' ? 180 : 0;
      x$ = this.game.add.tween(this.indicator);
      x$.to({
        angle: target
      }, 1000, Phaser.Easing.Quadratic.InOut, true);
      return this.swapSound.play('', 0, 1, false);
    };
    prototype.getPlayerKeys = function(color){
      var this$ = this;
      return function(){
        if (this$.currentColor === color) {
          return this$.arrowKeys;
        } else {
          return null;
        }
      };
    };
    prototype.toggleSound = function(){
      if (this.game.sound.mute) {
        this.soundToggle.loadTexture('sound');
        return this.game.sound.mute = false;
      } else {
        this.soundToggle.loadTexture('no-sound');
        return this.game.sound.mute = true;
      }
    };
    prototype.createGray = function(x, y, width, height, nextLevel){
      var gray, x$, y$;
      width == null && (width = 256);
      height == null && (height = 256);
      if (!nextLevel) {
        throw "Next level required!";
      }
      gray = new Phaser.Sprite(this.game, 0, 0, 'gray');
      this.game.physics.arcade.enable(gray);
      x$ = gray;
      x$.nextLevel = nextLevel;
      x$.anchor.setTo(0.5, 0.5);
      x$.width = width;
      x$.height = height;
      x$.x = x;
      x$.y = y;
      y$ = x$.body;
      y$.setSize(width * 0.9, height * 0.9);
      return x$;
    };
    return GameCore;
  }());
  customAddFunctions = function(game, core){
    each(function(color){
      game.add[color] = {
        player: function(x, y){
          var plr;
          plr = game.add.existing(new Player(game, core, x, y, color));
          if (color === 'black') {
            return core.blackPlayer = plr;
          } else {
            return core.whitePlayer = plr;
          }
        },
        platform: function(x, y, w, h){
          return core.platforms.add(new Platform(game, x, y, w, h, color));
        }
      };
      return game.add.danger = function(x, y, w, h){
        var dang, x$;
        dang = core.dangers.add(new Phaser.Sprite(game, x, y, 'red'));
        game.physics.arcade.enable(dang);
        x$ = dang;
        x$.width = w;
        x$.height = h;
        return x$;
      };
    })(
    ['black', 'white']);
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
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
