//
// ggj

package ggj.game {

import aspire.util.Log;

import flash.ui.Keyboard;

import flashbang.core.AppMode;
import flashbang.core.Flashbang;
import flashbang.core.GameObjectBase;
import flashbang.input.KeyboardState;

import ggj.GGJ;
import ggj.desc.GameDesc;
import ggj.game.control.PlayerControl;
import ggj.game.desc.BoardDesc;
import ggj.game.object.Actor;
import ggj.game.object.BattleBoard;
import ggj.rsrc.GGJResources;

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

        // setup the board
        _ctx.board = new BattleBoard(GameDesc.lib.getTome("test-board"));
        addObject(_ctx.board);

        // actors
        var p1 :PlayerControl = new PlayerControl(Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP,
            Keyboard.R, _keyboardState);
        addObject(new Actor(p1));
    }

    override protected function update (dt :Number) :void {
        while (dt > GGJ.FRAMERATE) {
            super.update(GGJ.FRAMERATE);
            dt -= GGJ.FRAMERATE;
        }
        if (dt > 0) {
            super.update(dt);
        }
        //_ctx.board.view.updateView();
    }

    protected var _ctx :BattleCtx;
    protected var _keyboardState :KeyboardState;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
