//
// ggj

package ggj {

import aspire.util.Log;

import flashbang.core.FlashbangApp;
import flashbang.core.FlashbangConfig;
import flashbang.resource.ResourceSet;

import ggj.debug.DebugOverlayMode;
import ggj.desc.GameDesc;
import ggj.game.BattleMode;
import ggj.rsrc.GGJResources;
import ggj.screens.LoadingMode;

import react.Future;

import starling.core.Starling;

public class GGJApp extends FlashbangApp
{
    override protected function run () :void {
        // init resources
        GameDesc.registerResourceLoader();
        const textureScale :int = (Starling.contentScaleFactor >= 2 ? 2 : 1);
        const resourceParams :GGJResources = getResourceParams();

        GGJ.init(resourceParams, textureScale);

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
        createViewport("debug").pushMode(new DebugOverlayMode());
        defaultViewport.unwindToMode(new BattleMode());
    }

    protected function getResourceParams () :GGJResources {
        throw new Error("abstract");
    }

    override protected function createConfig () :FlashbangConfig {
        const fbConfig :FlashbangConfig = new FlashbangConfig();
        fbConfig.windowWidth = this.stage.stageWidth;
        fbConfig.windowHeight = this.stage.stageHeight;
        fbConfig.stageWidth = fbConfig.windowWidth * 0.5;
        fbConfig.stageHeight = fbConfig.windowHeight * 0.5;
        return fbConfig;
    }

    protected static const log :Log = Log.getLog(GGJApp);
}
}
