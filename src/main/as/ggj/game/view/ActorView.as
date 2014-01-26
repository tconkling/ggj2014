package ggj.game.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;
import flashbang.util.DisplayUtil;

import ggj.game.object.Actor;

import starling.display.Quad;

public class ActorView extends BattleSpriteObject implements Updatable
{
    public function ActorView (actor :Actor) {
        _actor = actor;
    }

    override protected function added () :void {
        super.added();
        var bounds :Rectangle = _ctx.boardMgr.activeBoard.view.boardToViewBounds(_actor.bounds);

        _idle = ActorAnimation.createIdle(_actor.team.color);
        addObject(_idle, _sprite);
        _idle.display.x = bounds.width * 0.5;
        _idle.display.y = bounds.height;
        _idle.visible = true;

        _run = ActorAnimation.createRun(_actor.team.color);
        addObject(_run, _sprite);
        _run.display.x = bounds.width * 0.5;
        _run.display.y = bounds.height;

        var boundsView :Quad = DisplayUtil.fillRect(bounds.width, bounds.height, 0xffffff);
        boundsView.alpha = 0.1;
        _sprite.addChild(boundsView);
    }

    public function update (dt :Number) :void {
        var loc :Point = _ctx.boardMgr.activeBoard.view.boardToView(_actor.bounds.topLeft);
        if (loc.equals(new Point(_sprite.x, _sprite.y))) {
            _idle.visible = true;
        } else {
            _idle.visible = false;
            _sprite.x = loc.x;
            _sprite.y = loc.y;
        }
        _run.visible = !_idle.visible;
    }

    protected var _actor :Actor;
    protected var _idle :ActorAnimation;
    protected var _run :ActorAnimation;
}
}

