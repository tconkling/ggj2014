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

    public function get facingRight () :Boolean {
        return _facingRight;
    }

    public function set facingRight (value :Boolean) :void {
        if (_facingRight == value) return;

        _facingRight = value;
        _idle.facingRight = value;
        _run.facingRight = value;
        _jump.facingRight = value;
    }

    override protected function added () :void {
        super.added();
        var bounds :Rectangle = _ctx.boardMgr.activeBoard.view.boardToViewBounds(_actor.bounds);

        _facingRight = true;

        _idle = ActorAnimation.createIdle(_actor.team.color);
        addObject(_idle, _sprite);
        _idle.display.x = bounds.width * 0.5;
        _idle.display.y = bounds.height;
        _idle.visible = true;

        _run = ActorAnimation.createRun(_actor.team.color);
        addObject(_run, _sprite);
        _run.display.x = bounds.width * 0.5;
        _run.display.y = bounds.height;

        _jump = ActorAnimation.createJump(_actor.team.color, _ctx.params.jumpDuration);
        addObject(_jump, _sprite);
        _jump.display.x = bounds.width * 0.5;
        _jump.display.y = bounds.height;
        regs.add(_jump.done.connect(jumpDone));

        var boundsView :Quad = DisplayUtil.fillRect(bounds.width, bounds.height, 0xffffff);
        boundsView.alpha = 0.1;
        _sprite.addChild(boundsView);
    }

    public function update (dt :Number) :void {
        var loc :Point = _ctx.boardMgr.activeBoard.view.boardToView(_actor.bounds.topLeft);
        if (loc.equals(new Point(_sprite.x, _sprite.y))) {
            _idle.visible = true;
            _run.visible = false;
            _jump.visible = false;
        } else {
            _idle.visible = false;
            if (!_jump.visible) _run.visible = true;
            _sprite.x = loc.x;
            _sprite.y = loc.y;
        }
    }

    public function jump () :void {
        _idle.visible = _run.visible = false;
        _jump.visible = true;
    }

    public function jumpDone () :void {
        if (_jump.visible) {
            _jump.visible = false;
            _run.visible = true; // assume we're moving, our next frame will sort us out.
        }
    }

    protected var _actor :Actor;
    protected var _idle :ActorAnimation;
    protected var _run :ActorAnimation;
    protected var _jump :ActorAnimation;
    protected var _facingRight :Boolean;
}
}

