package ggj.game.object {

import aspire.geom.Vector2;

import flash.geom.Point;

import flashbang.core.Updatable;

import ggj.game.control.PlayerControl;
import ggj.game.view.ActorView;

public class Actor extends BattleObject implements Updatable
{
    public function Actor (input :PlayerControl) {
        _input = input;
        _loc.x = 6;
        _loc.y = 4;
    }

    override protected function added () :void {
        super.added();
        _view = new ActorView(this);
        addObject(_view, _ctx.boardLayer);
    }

    public function update (dt :Number) :void {
        _v.x = 0;

        if (_input.right) {
            _v.x = 5;
        } else if (_input.left) {
            _v.x = -5;
        }

        _loc.x += (_v.x * dt);
        _loc.y += (_v.y * dt);
    }

    public function get loc () :Point {
        return _loc;
    }

    protected var _input :PlayerControl;
    protected var _loc :Point = new Point();
    protected var _v :Vector2 = new Vector2();

    protected var _view :ActorView;
}
}
