
package ggj.game {

import aspire.util.Map;
import aspire.util.Maps;

import ggj.game.object.Team;

public class Scoreboard {
    public function Scoreboard () {
        for each (var team :Team in Team.values()) {
            _scores.put(team, 0);
        }
    }

    public function getScore (team :Team) :int {
        return _scores.get(team);
    }

    public function incrementScore (team :Team) :void {
        _scores.put(team, _scores.get(team) + 1);
    }

    protected var _scores :Map = Maps.newMapOf(Team);
}
}
