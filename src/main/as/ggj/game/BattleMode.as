//
// ggj

package ggj.game {

import aspire.util.Log;

import flashbang.core.Flashbang;
import flashbang.core.GameObjectBase;
import flashbang.core.AppMode;
import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import ggj.game.control.ControlTestObject;

import starling.display.Sprite;

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

        var disp :Sprite = MovieResource.createMovie("game/boy");
        disp.x = Flashbang.stageWidth * 0.5;
        disp.y = Flashbang.stageHeight * 0.5;
        addObject(new SpriteObject(disp), _modeSprite);

        addObject(new ControlTestObject());
    }

    protected var _ctx :BattleCtx;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
