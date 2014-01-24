//
// ggj-core

package ggj.util {

import flash.geom.Rectangle;

import flashbang.util.meter.SpriteMeterBase;
import flashbang.util.meter.MeterFill;
import flashbang.util.meter.MeterMetrics;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class DisplayObjectMeter extends SpriteMeterBase
{
    public function DisplayObjectMeter (disp :DisplayObject) {
        if (disp is Sprite) {
            _meterView = Sprite(disp);
        } else {
            _meterView = new Sprite();
            _meterView.addChild(disp);
        }

        _fill = MeterFill.LEFT_TO_RIGHT;
        _viewBounds = _meterView.getBounds(_meterView);
        addChild(_meterView);
    }

    public function get fill () :MeterFill {
        return _fill;
    }

    public function set fill (val :MeterFill) :void {
        if (_fill != val) {
            _fill = val;
            _needsDisplayUpdate = true;
        }
    }

    override protected function updateDisplay () :void {
        var normalizedVal :Number = this.normalizedValue;
        if (normalizedVal == 0) {
            _meterView.visible = false;
            return;
        }

        _meterView.visible = true;

        // clip our view?
        if (normalizedVal >= 1) {
            _meterView.clipRect = null;

        } else {
            var metrics :MeterMetrics =
                MeterMetrics.calculate(this, _viewBounds.width, _viewBounds.height, _fill, METRICS);

            _clipRect.setTo(_viewBounds.x + metrics.fgX, _viewBounds.y + metrics.fgY,
                metrics.fgWidth, metrics.fgHeight);
            _meterView.clipRect = _clipRect;
        }
    }

    protected var _meterView :Sprite;
    protected var _fill :MeterFill;
    protected var _viewBounds :Rectangle;
    protected var _clipRect :Rectangle = new Rectangle();

    protected static const METRICS :MeterMetrics = new MeterMetrics();
}
}
