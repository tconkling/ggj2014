package ggj.game.desc {

import aspire.util.Enum;

import flash.geom.Point;

public class PlayerColor extends Enum {
    public static const GREEN :PlayerColor = new PlayerColor("GREEN", "game/victory_green", 2, 0x25e857);
    public static const BLUE :PlayerColor = new PlayerColor("BLUE", "game/victory_blue", 3, 0x2ddff8);
    public static const YELLOW :PlayerColor = new PlayerColor("YELLOW", "game/victory_yellow", 1, 0xfed034);
    public static const RED :PlayerColor = new PlayerColor("RED", "game/victory_red", 0, 0xfb1923);
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

    public function get color () :uint {
        return _color;
    }

    public function get victoryMovieName () :String {
        return _victoryMovieName;
    }

    protected function getOffset (base :Point) :Point {
        var off :Point = base.clone();
        off.y += 4 * ordinal();
        return off;
    }

    /** @private */
    public function PlayerColor (name :String, victoryMovieName :String, powerViewIdx :int, color :uint) {
        super(name);
        _victoryMovieName = victoryMovieName;
        _powerViewIdx = powerViewIdx;
        _color = color;
    }

    protected var _victoryMovieName :String;
    protected var _powerViewIdx :int;
    protected var _color :uint;

    protected static const IDLE_OFFSET :Point = new Point(0, 0);
    protected static const RUN_OFFSET :Point = new Point(0, 1);
    protected static const JUMP_OFFSET :Point = new Point(0, 2);
    protected static const DEATH_OFFSET :Point = new Point(0, 3);
}
}
