package ggj.game.object {

import aspire.util.Enum;

public final class Team extends Enum
{
    public static const PLAYER_1 :Team = new Team("PLAYER_1", "game/boy");
    public static const PLAYER_2 :Team = new Team("PLAYER_2", "game/girl");
    finishedEnumerating(Team);

    public static function values () :Array {
        return Enum.values(Team);
    }

    public static function valueOf (name :String) :Team {
        return Enum.valueOf(Team, name) as Team;
    }

    public function get movieName () :String {
        return _movieName;
    }

    public function Team (name :String, movieName :String) {
        super(name);
        _movieName = movieName;
    }

    protected var _movieName :String;
}
}

