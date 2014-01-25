package ggj.game.object {

import aspire.geom.Vector2;
import aspire.util.MathUtil;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;

import ggj.game.control.PlayerControl;
import ggj.game.view.ActorView;

public class Actor extends BattleObject implements Updatable
{
    public function Actor (input :PlayerControl) {
        _input = input;

        _bounds = new Rectangle(1, 2, 1, 1);
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

        // gravity
        _v.y = MathUtil.clamp(_v.y + (GRAVITY * dt), MIN_V, MAX_V);

        _bounds.x += (_v.x * dt);
        _bounds.y += (_v.y * dt);

        // collide
        var collisions :Point = _ctx.board.getCollisions(_bounds, _lastBounds);
        if (collisions.x != _bounds.x) {
            // we had a horizontal collision. reset our horizontal velocity.
            _bounds.x = collisions.x;
            _v.x = 0;
        }
        if (collisions.y != _bounds.y) {
            // vertical collision
            _bounds.y = collisions.y;
            _v.y = 0;
        }
    }

    protected var _input :PlayerControl;
    protected var _bounds :Rectangle = new Rectangle();
    protected var _lastBounds :Rectangle = new Rectangle();
    protected var _v :Vector2 = new Vector2();

    protected var _view :ActorView;

    protected static const GRAVITY :Number = 10;
    protected static const MAX_V :Number = 10;
    protected static const MIN_V :Number = -10;
}
}
