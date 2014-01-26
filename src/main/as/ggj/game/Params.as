package ggj.game {

public class Params {
    public var gravity :Number = 40;
    public var jumpImpulse :Number = 15;
    public var maxFallSpeed :Number = 15;
    public var moveSpeed :Number = 7.5;

    /** Calculates duration of a jump on level ground */
    public function get jumpDuration () :Number {
        // too tired for mathing
        return 1.0;
    }
}
}
