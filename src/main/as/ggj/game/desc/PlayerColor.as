package ggj.game.desc {

import aspire.util.Enum;

public class PlayerColor extends Enum {
    public static const GREEN :PlayerColor = new PlayerColor("GREEN");
    public static const BLUE :PlayerColor = new PlayerColor("BLUE");
    public static const YELLOW :PlayerColor = new PlayerColor("YELLOW");
    public static const RED :PlayerColor = new PlayerColor("RED");
    finishedEnumerating(PlayerColor);

    public static function values () :Array {
        return Enum.values(PlayerColor);
    }

    public static function valueOf (name :String) :PlayerColor {
        return Enum.valueOf(PlayerColor, name) as PlayerColor;
    }

    /** @private */
    public function PlayerColor (name :String) {
        super(name);
    }
}
}
