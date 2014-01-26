
package ggj.game {

import aspire.util.Map;
import aspire.util.Maps;

import ggj.game.object.Team;

public class Scoreboard {
    public function get hasScore () :Boolean {
        return !_scores.isEmpty();
    }

    public function getScore (team :Team) :int {
        return (_scores.containsKey(team) ? _scores.get(team) : 0);
    }

    public function incrementScore (team :Team) :void {
        _scores.put(team, getScore(team) + 1);
    }

    protected var _scores :Map = Maps.newMapOf(Team);
}
}
