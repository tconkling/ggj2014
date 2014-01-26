package ggj.game.view {

import flash.geom.Rectangle;

import flashbang.objects.SpriteObject;

import ggj.game.object.Actor;

public class DeadActorView extends SpriteObject {
    public function DeadActorView (actor :Actor) {
        _actor = actor;
    }

    override protected function added () :void {
        var bounds :Rectangle = _actor.ctx.boardMgr.activeBoard.view.boardToViewBounds(_actor.bounds);

        var anim :ActorAnimation = ActorAnimation.createDeath(_actor.team.color);
        addObject(anim, _sprite);
        anim.display.x = bounds.width * 0.5;
        anim.display.y = bounds.height;
        anim.visible = true;
        regs.add(anim.done.connect(destroySelf));
    }

    protected var _actor :Actor;
}
}
