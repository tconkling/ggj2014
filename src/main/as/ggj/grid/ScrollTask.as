//
// ggj

package ggj.grid {

import aspire.util.Preconditions;

import flashbang.tasks.InterpolatingTask;

public class ScrollTask extends InterpolatingTask
{
    public function ScrollTask (x :Number, y :Number, time :Number = 0,
        easingFn :Function = null, target :BoardView = null) {
        super(time, easingFn);
        _toX = x;
        _toY = y;
        _target = target;
    }

    override protected function added () :void {
        super.added();
        // If we weren't given a target, operate on our parent object
        if (_target == null) {
            _target = this.parent as BoardView;
            Preconditions.checkState(_target != null, "parent is not a BoardView");
        }
    }

    override protected function updateValues () :void {
        if (isNaN(_fromX)) {
            _fromX = _target.scrollX;
            _fromY = _target.scrollY;
        }
        _target.setScroll(interpolate(_fromX, _toX), interpolate(_fromY, _toY));
    }

    protected var _toX :Number;
    protected var _toY :Number;
    protected var _fromX :Number = NaN;
    protected var _fromY :Number = NaN;
    protected var _target :BoardView;
}

}

