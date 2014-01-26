package ggj.game.object {

import aspire.util.Enum;

import ggj.game.desc.PlayerColor;

public final class Team extends Enum
{
    public static const PLAYER_1 :Team = new Team("PLAYER_1", PlayerColor.GREEN);
    public static const PLAYER_2 :Team = new Team("PLAYER_2", PlayerColor.BLUE);
    public static const PLAYER_3 :Team = new Team("PLAYER_3", PlayerColor.YELLOW);
    public static const PLAYER_4 :Team = new Team("PLAYER_4", PlayerColor.RED);
    finishedEnumerating(Team);

    public static function values () :Array {
        return Enum.values(Team);
    }

    public static function valueOf (name :String) :Team {
        return Enum.valueOf(Team, name) as Team;
    }

    public function get movieName () :String {
        return _color.playerAssetName;
    }

    public function Team (name :String, color :PlayerColor) {
        super(name);
        _color = color;
    }

    protected var _color :PlayerColor;
}
}

