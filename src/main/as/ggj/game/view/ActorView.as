package ggj.game.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;
import flashbang.resource.MovieResource;
import flashbang.util.DisplayUtil;

import flump.display.Movie;

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

        var movie :Movie = MovieResource.createMovie(_actor.team.movieName);
        movie.x = (bounds.width * 0.5);
        movie.y = bounds.height;
        _sprite.addChild(movie);

        var boundsView :Quad = DisplayUtil.fillRect(bounds.width, bounds.height, 0xffffff);
        boundsView.alpha = 0.5;
        _sprite.addChild(boundsView);
    }

    public function update (dt :Number) :void {
        var loc :Point = _ctx.boardMgr.activeBoard.view.boardToView(_actor.bounds.topLeft);
        _sprite.x = loc.x;
        _sprite.y = loc.y;
    }

    protected var _actor :Actor;
}
}
