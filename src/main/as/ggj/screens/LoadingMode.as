//
// ggj-core

package ggj.screens {

import flashbang.core.AppMode;
import flashbang.core.Flashbang;
import flashbang.core.GameObject;
import flashbang.core.ObjectTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;
import flashbang.util.TextFieldBuilder;

import starling.text.TextField;

public class LoadingMode extends AppMode
{
    override protected function setup () :void {
        _modeSprite.addChild(DisplayUtil.fillStageRect(0x0));

        const tf :TextField = new TextFieldBuilder("Loading")
            .font("_sans")
            .fontSize(40)
            .autoSize()
            .color(0xffffff)
            .build();

        tf.x = (Flashbang.stageWidth - tf.width) * 0.5;
        tf.y = (Flashbang.stageHeight - tf.height) * 0.5;
        _modeSprite.addChild(tf);

        var dots :String = "";
        const animator :GameObject = new GameObject();
        addObject(animator);
        animator.addObject(new RepeatingTask(function () :ObjectTask {
            return new SerialTask(
                new TimedTask(0.25),
                new FunctionTask(function () :void {
                    if (dots.length < 3) {
                        dots += ".";
                    } else {
                        dots = "";
                    }
                    tf.text = "Loading" + dots;
                }));
        }));

    }
}
}
