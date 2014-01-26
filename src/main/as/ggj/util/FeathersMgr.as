package ggj.util {

import feathers.core.DisplayListWatcher;
import feathers.core.FocusManager;
import feathers.core.PopUpManager;
import feathers.themes.MinimalMobileTheme;

import flashbang.core.GameObject;

public class FeathersMgr extends GameObject
{
    override protected function added () :void {
        FocusManager.isEnabled = true;
        PopUpManager.root = this.mode.modeSprite;
        _theme = new MinimalMobileTheme(this.mode.modeSprite);
    }

    override protected function dispose () :void {
        _theme.dispose();
    }

    protected var _theme :DisplayListWatcher;
}
}
