//
// ggj

package ggj {

import aspire.util.F;
import aspire.util.Log;

import flash.display.DisplayObject;

import flashbang.core.FlashbangApp;
import flashbang.core.FlashbangConfig;
import flashbang.resource.ResourceSet;
import flashbang.util.Timers;

import ggj.debug.DebugOverlayMode;
import ggj.desc.GameDesc;
import ggj.game.BattleMode;
import ggj.rsrc.GGJResources;
import ggj.screens.LoadingMode;

import react.Future;

import starling.core.Starling;

[SWF(width="1056", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class GGJApp extends FlashbangApp
{
    public function GGJApp (splashScreen :DisplayObject = null) {
        _splashScreen = splashScreen;
        if (_splashScreen != null) {
            addChild(splashScreen);
        }
    }

    override protected function run () :void {
        // init resources
        GameDesc.registerResourceLoader();
        const textureScale :int = (Starling.contentScaleFactor >= 2 ? 2 : 1);
        const resourceParams :GGJResources = new GGJResources();

        GGJ.init(resourceParams, textureScale);

        _running = true;
        loadResources();
    }

    protected function loadResources () :void {
        // Show a loading screen, and begin loading resources
        defaultViewport.changeMode(new LoadingMode());

        Future.sequence([getResourceSet().load(), GameDesc.load()])
            .onSuccess(onLoadingComplete)
            .onFailure(onFatalError);
    }

    override protected function initStarling () :Starling {
        var instance :Starling = super.initStarling();
        instance.stage.color = 0x606497;
        return instance;
    }

    protected function getResourceSet () :ResourceSet {
        const rsrcs :ResourceSet = new ResourceSet();
        rsrcs.add(GGJ.resourceParams.gameFlump);
        rsrcs.add(GGJ.resourceParams.futura50Font);
        rsrcs.add(GGJ.resourceParams.futura25Font);
        rsrcs.add(GGJ.resourceParams.helvetica24Font);
        rsrcs.add(GGJ.resourceParams.helvetica12Font);
        return rsrcs;
    }

    protected function onLoadingComplete () :void {
        // remove the splash screen after a frame
        if (_splashScreen != null) {
            Timers.delayFrame(F.bind(_splashScreen.parent.removeChild, _splashScreen));
            _splashScreen = null;
        }

        createViewport("debug").pushMode(new DebugOverlayMode());
        defaultViewport.unwindToMode(new BattleMode(2));
    }

    override protected function createConfig () :FlashbangConfig {
        const fbConfig :FlashbangConfig = new FlashbangConfig();
        fbConfig.windowWidth = this.stage.stageWidth;
        fbConfig.windowHeight = this.stage.stageHeight;
        fbConfig.stageWidth = fbConfig.windowWidth;
        fbConfig.stageHeight = fbConfig.windowHeight;
        return fbConfig;
    }

    protected var _splashScreen :DisplayObject;
    protected var _running :Boolean;

    protected static const log :Log = Log.getLog(GGJApp);
}
}
