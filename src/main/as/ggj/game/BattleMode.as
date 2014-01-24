//
// ggj

package ggj.game {
    
import aspire.util.Log;
import flashbang.core.GameObjectBase;
import flashbang.core.AppMode;

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
    }

    protected var _ctx :BattleCtx;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
