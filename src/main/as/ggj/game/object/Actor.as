package ggj.game.object {

import aspire.geom.Vector2;
import aspire.util.MathUtil;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.AppMode;
import flashbang.core.Updatable;

import ggj.GGJ;
import ggj.game.control.PlayerControl;
import ggj.game.desc.PlayerColor;
import ggj.game.desc.TileType;
import ggj.game.view.ActorView;
import ggj.game.view.DeadActorView;

public class Actor extends BattleObject implements Updatable
{
    public static function getAll (mode :AppMode) :Array {
        return mode.getObjectsInGroup(Actor);
    }

    public function Actor (team :Team, color :PlayerColor, x :Number, y :Number,
            input :PlayerControl) {
        _team = team;
        _color = color;
        _startLoc = new Point(x, y);
        _input = input;
        _bounds = new Rectangle(
            x + ((1 - GGJ.ACTOR_WIDTH) * 0.5),
            y - GGJ.ACTOR_HEIGHT,
            GGJ.ACTOR_WIDTH,
            GGJ.ACTOR_HEIGHT);
        _lastBounds = _bounds.clone();
    }

    public function get team () :Team {
        return _team;
    }

    public function get color () :PlayerColor {
        return _color;
    }

    public function get hitVictoryTile () :Boolean {
        return _hitVictoryTile;
    }

    public function get requestMapChange () :Boolean {
        return _ctx.stateMgr.playing && _input.power;
    }

    override public function get groups () :Array {
        return [ Actor ].concat(super.groups);
    }

    public function die () :void {
        var deadView :DeadActorView = new DeadActorView(this);
        var loc :Point = _ctx.boardMgr.activeBoard.view.boardToView(this.bounds.topLeft);
        deadView.display.x = loc.x;
        deadView.display.y = loc.y;
        this.mode.addObject(deadView, _ctx.boardLayer);

        destroySelf();

        // respawn (this.mode is null at this point)
        _ctx.mode.addObject(new Actor(_team, _color, _startLoc.x, _startLoc.y, _input));
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

        var shouldDie :Boolean = false;

        // vertical movement

        // jumping
        if (_ctx.stateMgr.playing && _input.jump && this.canJump) {
            _v.y += -_ctx.params.jumpImpulse;
            _view.jump();
        } else {
            // gravity
            _v.y += (_ctx.params.gravity * dt);
        }

        if (_ctx.stateMgr.playing && _input.jump) {
            _jumpButtonReleasedOnGround = false;
        }

        // clamp
        _v.y = MathUtil.clamp(_v.y, -_ctx.params.jumpImpulse, _ctx.params.maxFallSpeed);
        _bounds.y += (_v.y * dt);

        // vertical collisions
        if (_bounds.top != _lastBounds.top || _bounds.bottom != _lastBounds.bottom) {
            _onGround = false;
            var vCollision :Collision = _ctx.boardMgr.activeBoard.getCollisions(_bounds, _lastBounds, true, COLLISION);
            if (vCollision != null) {
                if (_bounds.y > _lastBounds.y) {
                    // we're on the ground
                    _onGround = true;
                    if (!_input.jump) {
                        _jumpButtonReleasedOnGround = true;
                    }
                }

                // vertical collision. reset vertical velocity.
                _bounds.y = vCollision.location;
                _v.y = 0;

                if (vCollision.tile.type.isSpike) {
                    shouldDie = true;
                }
            }
        }

        // horizontal movement
        if (_ctx.stateMgr.playing && _input.right) {
            _v.x = _ctx.params.moveSpeed;
        } else if (_ctx.stateMgr.playing && _input.left) {
            _v.x = -ctx.params.moveSpeed;
        } else {
            _v.x = 0;
        }
        _bounds.x += (_v.x * dt);
        if (_bounds.left != _lastBounds.left || _bounds.right != _lastBounds.right) {
            var hCollision :Collision = _ctx.boardMgr.activeBoard.getCollisions(_bounds, _lastBounds, false, COLLISION);
            if (hCollision != null) {
                _bounds.x = hCollision.location;
                _v.x = 0;
            }
        }

        if (Math.abs(_v.x) > 0) _view.facingRight = _v.x > 0;

        if (shouldDie) {
            die();
        } else if (_ctx.boardMgr.activeBoard.intersectsTile(_bounds, TileType.GOAL)) {
            // we win!
            _hitVictoryTile = true;
        }
    }

    protected function get canJump () :Boolean {
        return (_onGround && _jumpButtonReleasedOnGround);
    }

    protected var _team :Team;
    protected var _startLoc :Point;
    protected var _input :PlayerControl;
    protected var _view :ActorView;
    protected var _color :PlayerColor;

    // physics
    protected var _bounds :Rectangle = new Rectangle();
    protected var _lastBounds :Rectangle = new Rectangle();
    protected var _v :Vector2 = new Vector2();
    protected var _onGround :Boolean;
    protected var _jumpButtonReleasedOnGround :Boolean;

    protected var _hitVictoryTile :Boolean;
    protected var _requestedMapChange :Boolean;

    protected static const COLLISION :Collision = new Collision();
}
}
