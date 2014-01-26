package ggj.game.desc {

import aspire.util.Enum;

import flash.geom.Point;

public class PlayerColor extends Enum {
    public static const GREEN :PlayerColor = new PlayerColor("GREEN", 2);
    public static const BLUE :PlayerColor = new PlayerColor("BLUE", 3);
    public static const YELLOW :PlayerColor = new PlayerColor("YELLOW", 1);
    public static const RED :PlayerColor = new PlayerColor("RED", 0);
    finishedEnumerating(PlayerColor);

    public static function values () :Array {
        return Enum.values(PlayerColor);
    }

    public static function valueOf (name :String) :PlayerColor {
        return Enum.valueOf(PlayerColor, name) as PlayerColor;
    }

    public function get idleOffset () :Point {
        return getOffset(IDLE_OFFSET);
    }

    public function get runOffset () :Point {
        return getOffset(RUN_OFFSET);
    }

    public function get jumpOffset () :Point {
        return getOffset(JUMP_OFFSET);
    }

    public function get deathOffset () :Point {
        return getOffset(DEATH_OFFSET);
    }

    public function get powerViewIdx () :int {
        return _powerViewIdx;
    }

    protected function getOffset (base :Point) :Point {
        var off :Point = base.clone();
        off.y += 4 * ordinal();
        return off;
    }

    /** @private */
    public function PlayerColor (name :String, powerViewIdx :int) {
        super(name);
        _powerViewIdx = powerViewIdx;
    }

    protected static const IDLE_OFFSET :Point = new Point(0, 0);
    protected static const RUN_OFFSET :Point = new Point(0, 1);
    protected static const JUMP_OFFSET :Point = new Point(0, 2);
    protected static const DEATH_OFFSET :Point = new Point(0, 3);

    protected var _powerViewIdx :int;
}
}
