package ggj.game.view {

import flash.geom.Rectangle;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.LocationTask;
import flashbang.tasks.ParallelTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.util.Easing;

import flump.display.Movie;

import ggj.game.object.Actor;

public class DeadActorView extends SpriteObject {
    public function DeadActorView (actor :Actor) {
        var bounds :Rectangle = actor.ctx.boardMgr.activeBoard.view.boardToViewBounds(actor.bounds);
        var movie :Movie = MovieResource.createMovie(actor.team.movieName);
        movie.x = (bounds.width * 0.5);
        movie.y = bounds.height;
        _sprite.addChild(movie);

        addObject(new SerialTask(
            new ParallelTask(
                new LocationTask(movie.x, movie.y - 40, 0.5, Easing.easeIn, movie),
                new AlphaTask(0, 0.5)),
            new SelfDestructTask()));
    }
}
}
