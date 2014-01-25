package ggj.game.object {

import aspire.geom.Vector2;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;

import ggj.game.control.PlayerControl;
import ggj.game.view.ActorView;

public class Actor extends BattleObject implements Updatable
{
    public function Actor (input :PlayerControl) {
        _input = input;

        _bounds = new Rectangle(6, 4, 1, 1);
        _lastBounds = _bounds.clone();
    }

    override protected function added () :void {
        super.added();
        _view = new ActorView(this);
        addObject(_view, _ctx.boardLayer);
    }

    public function get bounds () :Rectangle {
        return _bounds;
    }

    public function update (dt :Number) :void {
        _lastBounds.copyFrom(_bounds);

        // update state from input
        _v.x = 0;
        if (_input.right) {
            _v.x = 5;
        } else if (_input.left) {
            _v.x = -5;
        }

        _bounds.x += (_v.x * dt);
        _bounds.y += (_v.y * dt);

        // collide
    }

    protected var _input :PlayerControl;
    protected var _bounds :Rectangle = new Rectangle();
    protected var _lastBounds :Rectangle = new Rectangle();
    protected var _v :Vector2 = new Vector2();

    protected var _view :ActorView;
}
}
