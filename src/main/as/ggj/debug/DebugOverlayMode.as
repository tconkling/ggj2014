//
// ggj

package ggj.debug {

import flashbang.core.AppMode;
import flashbang.core.Flashbang;
import flashbang.debug.FramerateView;

import starling.events.Touch;
import starling.text.TextFieldAutoSize;

public class DebugOverlayMode extends AppMode
{
    override protected function setup () :void {
        var fpsView :FramerateView = new FramerateView();
        fpsView.extendedData = false;
        fpsView.textField.text = "60";
        fpsView.textField.fontName = "futura25";
        fpsView.textField.fontSize = 12;
        fpsView.textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        fpsView.textField.x = Flashbang.stageWidth - fpsView.textField.width - 2;
        fpsView.textField.y = Flashbang.stageHeight - fpsView.textField.height - 2;
        addObject(fpsView, _modeSprite);
    }

    override protected function enter () :void {
        _modeSprite.touchable = false;
    }

    override public function handleTouches (touches :Vector.<Touch>) :void {
        // ignore touches so they don't get double-processed (otherwise hover events get
        // double-dispatched)
    }
}
}
