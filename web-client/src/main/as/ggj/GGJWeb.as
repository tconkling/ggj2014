//
// ggj-web

package ggj {

import ggj.rsrc.GGJResources;

import aspire.util.F;

import flash.display.DisplayObject;

import flashbang.util.Timers;

[SWF(width="960", height="640", frameRate="60", backgroundColor="#FFFFFF")]
public class GGJWeb extends GGJApp
{
    public function GGJWeb (splashScreen :DisplayObject = null) {
        _splashScreen = splashScreen;
        if (_splashScreen != null) {
            addChild(splashScreen);
        }
    }

    override protected function onLoadingComplete () :void {
        // remove the splash screen after a frame
        if (_splashScreen != null) {
            Timers.delayFrame(F.bind(_splashScreen.parent.removeChild, _splashScreen));
            _splashScreen = null;
        }

        super.onLoadingComplete();
    }

    override protected function getResourceParams () :GGJResources {
        return new WebResources();
    }

    protected var _splashScreen :DisplayObject;
}
}
