//
// ggj

package ggj.game.object {

import flashbang.core.GameObject;
import ggj.game.AutoCtx;
import ggj.game.BattleCtx;

public class BattleObject extends GameObject implements AutoCtx
{
    public function get ctx () :BattleCtx {
        return _ctx;
    }

    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }

    protected var _ctx :BattleCtx;
}
}
