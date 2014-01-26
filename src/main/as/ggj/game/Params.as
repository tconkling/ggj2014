package ggj.game {

public class Params {
    public var gravity :Number = 40;
    public var jumpImpulse :Number = 15;
    public var maxFallSpeed :Number = 15;

    public var moveAccel :Number = 100;
    public var moveDecel :Number = 100;
    public var maxMoveSpeed :Number = 10;

    /** Calculates duration of a jump on level ground */
    public function get jumpDuration () :Number {
        // too tired for mathing
        return 1.0;
    }
}
}
