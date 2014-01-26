package ggj.debug {

import feathers.controls.TextInput;

import flashbang.layout.HLayoutSprite;
import flashbang.objects.SpriteObject;

import ggj.util.Text;

public class ParamEditor extends SpriteObject {
    public function ParamEditor (object :Object, paramName :String) {
        _o = object;
        _paramName = paramName;
    }

    override protected function added () :void {
        var layout :HLayoutSprite = new HLayoutSprite();
        _sprite.addChild(layout);

        layout.addChild(Text.helvetica12(_paramName).color(0x0).build());

        var input :TextInput = Text.createInputText("", layout);
        layout.addChild(input);

        layout.layout();
    }

    protected var _o :Object;
    protected var _paramName :String;
}
}
