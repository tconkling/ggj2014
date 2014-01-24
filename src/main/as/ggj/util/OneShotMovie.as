//
// ggj-core

package ggj.util {

import flashbang.core.Updatable;
import flashbang.objects.MovieObject;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class OneShotMovie extends MovieObject implements Updatable
{
    public static function create (movieName :String) :OneShotMovie {
        return new OneShotMovie(MovieResource.createMovie(movieName));
    }

    public function OneShotMovie (movie :Movie) {
        super(movie);
        _movie.goTo(0);
        _movie.playOnce();
    }

    public function update (dt :Number) :void {
        if (_movie.frame >= _movie.numFrames - 1) {
            destroySelf();
        }
    }
}
}
