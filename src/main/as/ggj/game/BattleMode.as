//
// ggj

package ggj.game {

import aspire.util.Log;

import flash.ui.Keyboard;

import flashbang.core.AppMode;
import flashbang.core.GameObjectBase;
import flashbang.input.KeyboardState;

import ggj.GGJ;
import ggj.desc.GameDesc;
import ggj.game.control.PlayerControl;
import ggj.game.object.Actor;
import ggj.game.object.BattleBoard;
import ggj.game.object.GameState;
import ggj.game.object.GameStateMgr;
import ggj.game.object.Team;

public class BattleMode extends AppMode
{
    public function BattleMode () {
        _ctx = new BattleCtx();
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

        // controller objects
        addObject(_ctx.stateMgr = new GameStateMgr());
        addObject(_ctx.board = new BattleBoard(GameDesc.lib.getTome("test-board")));

        // actors
        var p1 :Actor = new Actor(Team.PLAYER_1, 1, 8,
            new PlayerControl(Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, Keyboard.R, _keyboardState));
        var p2 :Actor = new Actor(Team.PLAYER_2, 2, 8,
            new PlayerControl(Keyboard.A, Keyboard.D, Keyboard.W, Keyboard.SPACE, _keyboardState));
        addObject(p1);
        addObject(p2);
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
                text = "" + _ctx.stateMgr.winner.team.name();
            }
            _viewport.pushMode(new GameOverMode(text));
        }
    }

    protected var _ctx :BattleCtx;
    protected var _keyboardState :KeyboardState;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
