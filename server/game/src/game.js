// Generated by LiveScript 1.2.0
(function(){
  var ref$, each, map, filter, first, head, lines, keys, values, GameCore, customAddFunctions;
  ref$ = require('prelude-ls'), each = ref$.each, map = ref$.map, filter = ref$.filter, first = ref$.first, head = ref$.head, lines = ref$.lines, keys = ref$.keys, values = ref$.values;
  this.GameCore = GameCore = (function(){
    GameCore.displayName = 'GameCore';
    var prototype = GameCore.prototype, constructor = GameCore;
    function GameCore(game){
      this.switchPlayers = bind$(this, 'switchPlayers', prototype);
      this.currentPlayer = bind$(this, 'currentPlayer', prototype);
      this.game = game;
    }
    prototype.preload = function(){
      var asset, x$;
      asset = function(p){
        return "game/assets/" + p;
      };
      x$ = this.game.load;
      x$.tilemap('test-map', asset('maps/test-map.json'), null, Phaser.Tilemap.TILED_JSON);
      x$.image('test-tiles', asset('gfx/tiles/black-and-white.png'));
      x$.image('black-and-white', asset('gfx/tiles/black-and-white-big.png'));
      x$.image('black', asset('gfx/tiles/black.png'));
      x$.image('white', asset('gfx/tiles/white.png'));
      x$.image('empty', asset('gfx/tiles/empty.png'));
      x$.image('indicator', asset('gfx/ui/indicator.png'));
      x$.image('locator', asset('gfx/ui/locator.png'));
      x$.audio('hit-ground-1', asset('sfx/hit-ground-1.ogg'));
      x$.spritesheet('player-black', asset('gfx/player/black.png'), 84, 84);
      x$.spritesheet('player-white', asset('gfx/player/white.png'), 84, 84);
    };
    prototype.create = function(){
      customAddFunctions(this.game);
      (function(add, physics, world, camera){
        var x$, y$, z$, z1$, z2$, z3$, z4$, this$ = this;
        this.game.stage.backgroundColor = '#FFFFFF';
        this.game.time.advancedTiming = true;
        physics.startSystem(Phaser.Physics.ARCADE);
        world.setBounds(0, 0, 800, 600);
        x$ = this.platforms = add.group();
        y$ = x$.add(Platform.create.black(this.game, 135, 500, 516, 74));
        y$.name = "Upper";
        z$ = x$.add(Platform.create.black(this.game, 20, 550, 700, 100));
        z$.name = "Lower";
        z1$ = this.specialPlat = this.platforms.add(Platform.create.black(this.game, 20, 20, 100, 100));
        z1$.name = "Special";
        this.blackPlayer = add.black.player(210, 210);
        this.whitePlayer = add.white.player(416, 150);
        camera.follow(this.blackPlayer);
        this.currentColor = 'black';
        z2$ = this.locator = add.sprite(0, 0, 'locator');
        z2$.anchor.setTo(0.5, 0.5);
        z3$ = this.gui = add.group();
        z3$.fixedToCamera = true;
        z4$ = this.indicator = this.gui.create(700, 100, 'indicator');
        z4$.anchor.setTo(0.5, 0.5);
        z4$.angle = 180;
        this.arrowKeys = this.game.input.keyboard.createCursorKeys();
        each(function(it){
          return it.arrowKeys = this$.getPlayerKeys(it.color);
        })(
        [this.blackPlayer, this.whitePlayer]);
        this.switchKey = this.game.input.keyboard.addKey(Phaser.Keyboard.TAB);
        this.switchKey.onDown.add(this.switchPlayers);
      }.call(this, this.game.add, this.game.physics, this.game.world, this.game.camera));
    };
    prototype.update = function(){
      (function(collide){
        collide(this.blackPlayer);
        collide(this.whitePlayer);
      }.call(this, PlatformCollision.collide(this.game.physics.arcade, this.platforms)));
      (function(player){
        if (player) {
          this.locator.x = player.x;
          this.locator.y = player.y - player.body.height;
        }
      }.call(this, this.currentPlayer()));
      (function(mouse){
        if (this.game.input.mousePointer.isDown) {
          this.game.physics.arcade.moveToPointer(this.specialPlat.inside, 200);
        } else {
          this.specialPlat.body.velocity.setTo(0, 0);
        }
      }.call(this, this.game.input.mousePointer));
    };
    prototype.render = function(){
      'ass';
    };
    prototype.currentPlayer = function(){
      switch (this.currentColor) {
      case 'black':
        return this.blackPlayer;
      case 'white':
        return this.whitePlayer;
      default:
        throw "why even try";
      }
    };
    prototype.playerColors = ['black', 'white'];
    prototype.switchPlayers = function(){
      var target, this$ = this;
      this.currentColor = head(filter(function(it){
        return it !== this$.currentColor;
      }, this.playerColors));
      this.game.camera.follow(this.currentPlayer());
      target = this.currentColor === 'black' ? 180 : 0;
      return this.game.add.tween(this.indicator).to({
        angle: target
      }, 1000, Phaser.Easing.Quadratic.InOut, true);
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
    return GameCore;
  }());
  customAddFunctions = function(game){
    each(function(color){
      return game.add[color] = {
        player: function(x, y){
          return game.add.existing(new Player(game, x, y, color));
        },
        platform: function(x, y, w, h){
          return game.add.existing(new Platform(game, x, y, w, h, color));
        }
      };
    })(
    ['black', 'white']);
  };
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
