package ggj.game.object {

import aspire.geom.Vector2;

import flash.geom.Point;

import ggj.game.view.ActorView;

public class Actor extends BattleObject
{
    public function Actor () {
        _loc.x = 6;
        _loc.y = 4;
    }

    override protected function added () :void {
        super.added();
        _view = new ActorView(this);
        addObject(_view, _ctx.boardLayer);
    }

    public function get loc () :Point {
        return _loc;
    }

    protected var _loc :Point = new Point();
    protected var _v :Vector2 = new Vector2();

    protected var _view :ActorView;
}
}
