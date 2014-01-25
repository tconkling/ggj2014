package ggj.game.control {

import flashbang.input.KeyboardState;

public class PlayerControl {
    public function PlayerControl (left :uint, right :uint, jump :uint, state :KeyboardState) {
        _left = left;
        _right = right;
        _jump = jump;
        _state = state;
    }

    public function get direction () :ControlDirection {
        return _state.isKeyDown(_left) ? ControlDirection.LEFT :
            (_state.isKeyDown(_right) ? ControlDirection.RIGHT : ControlDirection.NONE);
    }

    public function get jumping () :Boolean {
        return _state.isKeyDown(_jump);
    }

    protected var _left :uint;
    protected var _right :uint;
    protected var _jump :uint;
    protected var _state :KeyboardState;
}
}
