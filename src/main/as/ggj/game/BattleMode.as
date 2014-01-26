//
// ggj

package ggj.game {

import aspire.util.Log;

import flash.ui.Keyboard;

import flashbang.core.AppMode;
import flashbang.core.Flashbang;
import flashbang.core.GameObjectBase;
import flashbang.input.KeyboardState;
import flashbang.layout.HLayoutSprite;

import ggj.GGJ;
import ggj.debug.ParamEditor;
import ggj.desc.GameDesc;
import ggj.game.control.PlayerControl;
import ggj.game.desc.PlayerColor;
import ggj.game.object.Actor;
import ggj.game.object.BattleBoard;
import ggj.game.object.GameState;
import ggj.game.object.GameStateMgr;
import ggj.game.object.Team;
import ggj.game.object.Tile;
import ggj.util.FeathersMgr;

public class BattleMode extends AppMode
{
    public function BattleMode (numPlayers :int) {
        _ctx = new BattleCtx();
        _numPlayers = numPlayers;
    }

    override protected function registerObject (obj :GameObjectBase) :void {
        if (obj is AutoCtx) {
            AutoCtx(obj).setCtx(_ctx);
        }
        super.registerObject(obj);
    }

    override protected function setup () :void {
        addObject(_ctx);

        // input
        _keyboardState = new KeyboardState();
        this.keyboardInput.registerListener(_keyboardState);

        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);
        _modeSprite.addChild(_ctx.debugLayer);

        // controller objects
        addObject(_ctx.stateMgr = new GameStateMgr());

        // boards - separate loops because activeBoard must be valid before adding Actors.
        var active :Boolean = GGJ.RAND.getIntInRange(0, _numPlayers);
        for (var ii :int = 0; ii < _numPlayers; ii++) {
            var board :BattleBoard = new BattleBoard(GameDesc.lib.getTome(BOARD_NAMES[ii]),
                PlayerColor.values()[ii]);
            addObject(board);
            if (ii == active) {
                _ctx.activeBoard = board;
            } else {
                board.view.display.alpha = 0.2;
            }
            _ctx.boards.push(board);
        }

        // actors
        var spawnTile :Tile = _ctx.activeBoard.spawnTile;
        for (ii = 0; ii < _numPlayers; ii++) {
            var left :uint  = CONTROLS[0 + ii * 4];
            var right :uint = CONTROLS[1 + ii * 4];
            var jump :uint  = CONTROLS[2 + ii * 4];
            var power :uint = CONTROLS[3 + ii * 4];
            addObject(new Actor(Team.values()[ii], spawnTile.x + (ii * 0.25), spawnTile.y,
                new PlayerControl(left, right, jump, power, _keyboardState)));
        }

        // parameter editing
        addObject(new FeathersMgr());
        var debugLayout :HLayoutSprite = new HLayoutSprite();
        _ctx.debugLayer.addChild(debugLayout);
        addObject(new ParamEditor(_ctx.params, "gravity"), debugLayout);
        debugLayout.layout();
        debugLayout.y = Flashbang.stageHeight - debugLayout.height;
    }

    override protected function update (dt :Number) :void {
        while (dt > 0 && !_ctx.stateMgr.isGameOver) {
            var thisDt :Number = Math.min(dt, GGJ.FRAMERATE);
            super.update(thisDt);
            dt -= thisDt;
        }

        if (_ctx.stateMgr.isGameOver) {
            var text :String = "";
            if (_ctx.stateMgr.state == GameState.EVERYONE_DIED) {
                text = "Everybody died!";
            } else if (_ctx.stateMgr.state == GameState.HAS_WINNER) {
                text = "" + _ctx.stateMgr.winner.team.name() + " wins!";
            }
            _viewport.pushMode(new GameOverMode(text));
        }
    }

    protected static const BOARD_NAMES :Vector.<String> = new <String>[
        "rgby_layout_1", "rgby_layout_2"
    ];

    // per player: left move, right move, jump, power
    protected static const CONTROLS :Vector.<uint> = new <uint>[
        Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, Keyboard.R,     // player 1
        Keyboard.A,    Keyboard.D,     Keyboard.SPACE,  Keyboard.W, // player 2
        Keyboard.U,    Keyboard.I,     Keyboard.O,  Keyboard.P,     // player 3
        Keyboard.V,    Keyboard.B,     Keyboard.N,  Keyboard.M      // player 4
    ];

    protected var _ctx :BattleCtx;
    protected var _numPlayers :int;
    protected var _keyboardState :KeyboardState;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
