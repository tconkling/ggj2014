//
// ggj-core

package ggj.util {

import feathers.controls.TextInput;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.ITextRenderer;
import feathers.text.BitmapFontTextFormat;

import flashbang.util.TextFieldBuilder;

import starling.display.Sprite;

public class Text
{
    public static const FUTURA_50_NAME :String = "futura50";
    public static const FUTURA_25_NAME :String = "futura25";
    public static const HELVETICA_24_NAME :String = "helvetica24";
    public static const HELVETICA_12_NAME :String = "helvetica12";

    public static function createInputText (prompt :String, parent :Sprite, width :Number = 100) :TextInput {
        var textInput :TextInput = new TextInput();

        // add the TextInput to the sprite before changing its properties, or they'll be overridden
        // by feathers
        parent.addChild(textInput);

        textInput.promptFactory = function () :ITextRenderer {
            var tr :BitmapFontTextRenderer = new BitmapFontTextRenderer();
            tr.textFormat = new BitmapFontTextFormat(HELVETICA_24_NAME, 10, 0x666666);
            return tr;
        };
        textInput.promptProperties = null;
        textInput.prompt = prompt;
        textInput.width = width;
        textInput.height = 22;
        textInput.textEditorProperties.fontName = "Helvetica";
        textInput.textEditorProperties.fontSize = 12;
        textInput.textEditorProperties.color = 0x0;

        return textInput;
    }

    public static function pluralize (count :int, name :String) :String {
        return "" + count + " " + (count == 1 ? name : name + "s");
    }

    public static function futura50 (text :String = "") :TextFieldBuilder {
        return new TextFieldBuilder(text)
            .font(FUTURA_50_NAME)
            .bitmapFontNativeSize()
            .color(0xffffff)
            .autoSize();
    }

    public static function futura25 (text :String = "") :TextFieldBuilder {
        return new TextFieldBuilder(text)
            .font(FUTURA_25_NAME)
            .bitmapFontNativeSize()
            .color(0xffffff)
            .autoSize();
    }

    public static function helvetica24 (text :String = "") :TextFieldBuilder {
        return new TextFieldBuilder(text)
            .font(HELVETICA_24_NAME)
            .bitmapFontNativeSize()
            .color(0xffffff)
            .autoSize();
    }

    public static function helvetica12 (text :String = "") :TextFieldBuilder {
        return new TextFieldBuilder(text)
            .font(HELVETICA_12_NAME)
            .bitmapFontNativeSize()
            .color(0xffffff)
            .autoSize();
    }
}
}
