package ggj.game {

import flashbang.core.AppMode;
import flashbang.resource.MovieResource;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;

import flump.display.Movie;

import ggj.GGJ;
import ggj.game.object.Team;

public class GameOverMode extends AppMode {
    public function GameOverMode (winner :Team) {
        // dim background
        _modeSprite.addChild(DisplayUtil.fillStageRect(0x0, 0.7));

        var winnerMovie :Movie = MovieResource.createMovie(winner.color.victoryMovieName);
        DisplayUtil.center(winnerMovie, _modeSprite);
        _modeSprite.addChild(winnerMovie);

        // restart the game after a second
        addObject(new SerialTask(
            new TimedTask(2),
            new AlphaTask(0, 0.25, null, _modeSprite),
            new FunctionTask(function () :void {
                _viewport.unwindToMode(new BattleMode(GGJ.NUM_PLAYERS));
            })));
    }
}
}
