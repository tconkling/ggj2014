package ggj.game.object {

import aspire.geom.Vector2;
import aspire.util.MathUtil;

import flash.geom.Rectangle;

import flashbang.core.Updatable;

import ggj.game.control.PlayerControl;
import ggj.game.view.ActorView;

public class Actor extends BattleObject implements Updatable
{
    public function Actor (input :PlayerControl) {
        _input = input;

        _bounds = new Rectangle(1, 2, 0.9, 0.9);
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

        // vertical movement

        // jumping
        if (_input.jump && this.canJump) {
            _isJumping = true;
            _v.y += JUMP_IMPULSE;
        } else {
            // gravity
            _v.y += (GRAVITY * dt);
        }

        // clamp
        _v.y = MathUtil.clamp(_v.y, MIN_V, MAX_V);
        _bounds.y += (_v.y * dt);

        // vertical collisions
        _onGround = false;
        var vCollision :Number = _ctx.board.getCollisions(_bounds, _lastBounds, true);
        if (!isNaN(vCollision)) {
            if (_bounds.y > _lastBounds.y) {
                // we're on the ground
                _onGround = true;
                if (!_input.jump) {
                    _isJumping = false;
                }
            }

            // vertical collision. reset vertical velocity.
            _bounds.y = vCollision;
            _v.y = 0;
        }

        // horizontal movement

        if (_input.right) {
            _v.x = 5;
        } else if (_input.left) {
            _v.x = -5;
        } else {
            _v.x = 0;
        }
        _bounds.x += (_v.x * dt);
        var hCollision :Number = _ctx.board.getCollisions(_bounds, _lastBounds, false);
        if (!isNaN(hCollision)) {
            _bounds.x = hCollision;
            _v.x = 0;
        }
    }

    protected function get canJump () :Boolean {
        return (_onGround && !_isJumping);
    }

    protected var _input :PlayerControl;
    protected var _view :ActorView;

    // physics
    protected var _bounds :Rectangle = new Rectangle();
    protected var _lastBounds :Rectangle = new Rectangle();
    protected var _v :Vector2 = new Vector2();
    protected var _onGround :Boolean;
    protected var _isJumping :Boolean;

    protected static const JUMP_IMPULSE :Number = -10;
    protected static const GRAVITY :Number = 20;
    protected static const MAX_V :Number = 10;
    protected static const MIN_V :Number = -10;
}
}
