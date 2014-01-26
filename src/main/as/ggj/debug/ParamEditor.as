package ggj.debug {

import feathers.controls.TextInput;
import feathers.events.FeathersEventType;

import flashbang.layout.HLayoutSprite;
import flashbang.objects.SpriteObject;

import ggj.util.Text;

import aspire.util.StringUtil;

public class ParamEditor extends SpriteObject {
    public function ParamEditor (object :Object, paramName :String) {
        _o = object;
        _paramName = paramName;
    }

    override protected function added () :void {
        var layout :HLayoutSprite = new HLayoutSprite();
        _sprite.addChild(layout);

        layout.addChild(Text.helvetica12(_paramName).color(0x0).build());

        var input :TextInput = Text.createInputText("", layout, 40);
        input.restrict = "0123456789.-";
        input.text = "" + (_o[_paramName] as Number);
        layout.addChild(input);

        layout.layout();

        this.regs.addEventListener(input, FeathersEventType.ENTER, function () :void {
            try {
                var val :Number = StringUtil.parseNumber(input.text);
                _o[_paramName] = val;
                input.clearFocus();
            } catch (e :Error) {
                input.text = "" + (_o[_paramName] as Number);
            }

            input.selectRange(0, input.text.length);
        });
    }

    protected var _o :Object;
    protected var _paramName :String;
}
}
