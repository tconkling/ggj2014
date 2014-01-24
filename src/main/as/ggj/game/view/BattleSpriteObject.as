//
// ggj

package ggj.game.view {

import flashbang.objects.SpriteObject;

import starling.display.Sprite;
import ggj.game.AutoCtx;
import ggj.game.BattleCtx;

public class BattleSpriteObject extends SpriteObject implements AutoCtx
{
    public function BattleSpriteObject (sprite :Sprite = null) {
        super(sprite);
    }

    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }

    protected var _ctx :BattleCtx;
}
}
