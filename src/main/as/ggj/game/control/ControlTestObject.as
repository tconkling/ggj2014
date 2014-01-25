package ggj.game.control {

import aspire.util.Log;

import flash.ui.Keyboard;

import flashbang.core.GameObject;
import flashbang.core.Updatable;
import flashbang.input.KeyboardState;

public class ControlTestObject extends GameObject implements Updatable {
    override protected function added () :void {
        var state :KeyboardState = new KeyboardState();
        mode.keyboardInput.registerListener(state);
        _p1 = new PlayerControl(Keyboard.Q, Keyboard.W, Keyboard.E, Keyboard.R, state);
        _p2 = new PlayerControl(Keyboard.A, Keyboard.S, Keyboard.D, Keyboard.F, state);
        _p3 = new PlayerControl(Keyboard.U, Keyboard.I, Keyboard.O, Keyboard.P, state);
        _p4 = new PlayerControl(Keyboard.J, Keyboard.K, Keyboard.L, Keyboard.SEMICOLON, state);
    }

    public function update (dt :Number) :void {
        /* TESTING
        log.info("Control update",
            "p1", _p1.direction + "|" + _p1.jumping,
            "p2", _p2.direction + "|" + _p2.jumping,
            "p3", _p3.direction + "|" + _p3.jumping,
            "p4", _p4.direction + "|" + _p4.jumping);
        */
    }

    protected var _p1 :PlayerControl;
    protected var _p2 :PlayerControl;
    protected var _p3 :PlayerControl;
    protected var _p4 :PlayerControl;

    private static const log :Log = Log.getLog(ControlTestObject);
}
}
