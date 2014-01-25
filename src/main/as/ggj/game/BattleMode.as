//
// ggj

package ggj.game {

import aspire.util.Log;

import flashbang.core.AppMode;
import flashbang.core.GameObjectBase;

import ggj.game.control.ControlTestObject;
import ggj.game.object.Actor;
import ggj.game.object.BattleBoard;

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

        addObject(new ControlTestObject());

        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);

        // setup the board
        _ctx.board = new BattleBoard();
        addObject(_ctx.board);

        addObject(new Actor());
    }

    override protected function update (dt :Number) :void {
        super.update(dt);
        //_ctx.board.view.updateView();
    }

    protected var _ctx :BattleCtx;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
