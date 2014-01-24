//
// ggj-mobile

package ggj {

import aspire.util.F;
import aspire.util.Log;

import flashbang.core.FlashbangConfig;
import flashbang.util.Timers;

import ggj.rsrc.GGJResources;
import ggj.util.NSLogTarget;

import flash.display.DisplayObject;
import flash.system.Capabilities;

[SWF(frameRate="60", backgroundColor="#000000")]
public class GGJMobile extends GGJApp
{
    public function GGJMobile (splashScreen :DisplayObject = null) {
        _splashScreen = splashScreen;
        if (_splashScreen != null) {
            addChild(splashScreen);
        }

        // Send our log statements to NSLog
        Log.addTarget(new NSLogTarget());
    }

    override protected function onLoadingComplete () :void {
        // remove the splash screen after a frame
        if (_splashScreen != null) {
            Timers.delayFrame(F.bind(_splashScreen.parent.removeChild, _splashScreen));
            _splashScreen = null;
        }

        super.onLoadingComplete();
    }

    override protected function run () :void {
        super.run();

        // Enable auto-orientation. Doing this earlier, like in the AIR descriptor,
        // causes the app to incorrectly auto-orient to portrait mode.
        this.stage.autoOrients = true;
    }

    override protected function getResourceParams () :GGJResources {
        return new MobileResources();
    }

    override protected function createConfig () :FlashbangConfig {
        var config :FlashbangConfig = super.createConfig();

        const resX :Number = Capabilities.screenResolutionX;
        const resY :Number = Capabilities.screenResolutionY;

        // swap window width/height on devices that report portrait-mode resolutions (like iOS)
        config.windowWidth = Math.max(resX, resY);
        config.windowHeight = Math.min(resX, resY);

        // find the closest power-of-two divisor for our target stage size
        // (the size of the stage that the game was designed for)
        var targetWidth :Number;
        var targetHeight :Number;
        if (config.windowWidth > config.windowHeight) {
            targetWidth = TARGET_STAGE_WIDTH;
            targetHeight = TARGET_STAGE_HEIGHT;
        } else {
            targetWidth = TARGET_STAGE_HEIGHT;
            targetHeight = TARGET_STAGE_WIDTH;
        }
        var divisor :int = 1;
        while (config.windowWidth / (divisor * 2) >= targetWidth ||
               config.windowHeight / (divisor * 2) >= targetHeight) {
            divisor *= 2;
        }

        config.stageWidth = config.windowWidth / divisor;
        config.stageHeight = config.windowHeight / divisor;
        return config;
    }

    protected var _splashScreen :DisplayObject;

    protected static const TARGET_STAGE_WIDTH :Number = 480;
    protected static const TARGET_STAGE_HEIGHT :Number = 320;

    protected static const TESTFLIGHT_APP_TOKEN :String = "8a6a9fe6-8aef-4215-afd6-3cda05ec178c";
}
}
