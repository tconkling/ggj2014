//
// ggj-core

package ggj.util {

import flashbang.util.TextFieldBuilder;

public class Text
{
    public static const FUTURA_50_NAME :String = "futura50";
    public static const FUTURA_25_NAME :String = "futura25";
    public static const HELVETICA_24_NAME :String = "helvetica24";
    public static const HELVETICA_12_NAME :String = "helvetica12";

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
