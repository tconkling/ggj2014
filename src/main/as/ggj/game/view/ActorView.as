package ggj.game.view {

import flash.geom.Point;

import flashbang.core.Updatable;
import flashbang.resource.MovieResource;

import ggj.game.object.Actor;

public class ActorView extends BattleSpriteObject implements Updatable
{
    public function ActorView (actor :Actor) {
        _actor = actor;
        _sprite.addChild(MovieResource.createMovie("game/boy"));
    }

    public function update (dt :Number) :void {
        var loc :Point = _ctx.board.view.boardToView(_actor.loc);
        _sprite.x = loc.x;
        _sprite.y = loc.y;
    }

    protected var _actor :Actor;
}
}
