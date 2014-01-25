package ggj.game.control {

import flashbang.input.KeyboardState;

public class PlayerControl {
    public function PlayerControl (left :uint, right :uint, jump :uint, power :uint,
            state :KeyboardState) {
        _left = left;
        _right = right;
        _jump = jump;
        _power = power;
        _state = state;
    }

    public function get left () :Boolean {
        return _state.isKeyDown(_left);
    }

    public function get right () :Boolean {
        return _state.isKeyDown(_right);
    }

    public function get jump () :Boolean {
        return _state.isKeyDown(_jump);
    }

    public function get power () :Boolean {
        return _state.isKeyDown(_power);
    }

    protected var _left :uint;
    protected var _right :uint;
    protected var _jump :uint;
    protected var _power :uint;
    protected var _state :KeyboardState;
}
}
