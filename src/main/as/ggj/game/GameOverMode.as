package ggj.game {

import flashbang.core.AppMode;
import flashbang.layout.VLayoutSprite;
import flashbang.objects.SimpleTextButton;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.CallbackTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;

import ggj.GGJ;
import ggj.util.Text;

import starling.display.Sprite;

public class GameOverMode extends AppMode {
    public function GameOverMode (text :String) {
        // dim background
        _modeSprite.addChild(DisplayUtil.fillStageRect(0x0, 0.7));

        var layout :VLayoutSprite = new VLayoutSprite();
        layout.addChild(Text.futura25("Game Over!").color(0xffffff).build());
        layout.addChild(Text.helvetica24(text).color(0x0).build());
        layout.addVSpacer(15);

        layout.layout();

        const HMARGIN :Number = 10;
        const VMARGIN :Number = 15;
        var bg :Sprite = DisplayUtil.outlineFillRect(
            layout.width + (HMARGIN * 2),
            layout.height + (VMARGIN * 2),
            0xffffff,
            2, 0x0);
        DisplayUtil.center(bg, _modeSprite);
        _modeSprite.addChild(bg);

        DisplayUtil.center(layout, _modeSprite);
        _modeSprite.addChild(layout);

        // restart the game after a second
        addObject(new SerialTask(
            new TimedTask(1),
            new AlphaTask(0, 0.25, null, layout),
            new FunctionTask(function () :void {
                _viewport.unwindToMode(new BattleMode(GGJ.NUM_PLAYERS));
            })));
    }
}
}
