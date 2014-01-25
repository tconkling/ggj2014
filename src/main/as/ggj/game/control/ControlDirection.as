package ggj.game.control {

import aspire.util.Enum;

public class ControlDirection extends Enum {
    public static const LEFT :ControlDirection = new ControlDirection("LEFT");
    public static const RIGHT :ControlDirection = new ControlDirection("RIGHT");
    public static const NONE :ControlDirection = new ControlDirection("NONE");
    finishedEnumerating(ControlDirection);

    public static function values () :Array {
        return Enum.values(ControlDirection);
    }

    public static function valueOf (name :String) :ControlDirection {
        return Enum.valueOf(ControlDirection, name) as ControlDirection;
    }

    /* @private */
    public function ControlDirection (name :String) {
        super(name);
    }
}
}
