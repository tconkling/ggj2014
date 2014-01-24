//
// ggj-core

package ggj.util {

import flashbang.resource.ImageResource;

import flump.display.Movie;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.filters.ColorMatrixFilter;

public class GGJUtil
{
    public static function grayscaleFilter () :ColorMatrixFilter {
        var f :ColorMatrixFilter = new ColorMatrixFilter();
        f.adjustSaturation(-1);
        return f;
    }

    public static function fillCircle (radius :Number, color :uint) :Image {
        var img :Image = ImageResource.createImage("base/img_circle");
        img.color = color;

        img.pivotX = img.width * 0.5;
        img.pivotY = img.height * 0.5;

        var size :Number = radius * 2;
        var scale :Number = Math.min(size / img.width, size / img.height);
        img.scaleX = img.scaleY = scale;

        return img;
    }

    /**
     * Recursively recolors all Quad descendents of the given displayObject.
     * Return the given displayObject, for chaining.
     */
    public static function recolor (disp :DisplayObject, color :uint) :DisplayObject {
        recolorImpl(disp, color, RECOLOR_ALL);
        return disp;
    }

    /**
     * Recursively recolors the given displayObject and any of its children named "recolor".
     * Return the given displayObject, for chaining.
     */
    public static function recolorNamedLayers (disp :DisplayObject, color :uint) :DisplayObject {
        recolorImpl(disp, color, HAS_RECOLOR_NAME);
        return disp;
    }

    public static function recolorMovie (movie :Movie, color :uint) :Movie {
        var curFrame :int = movie.frame;
        for (var ii :int = 0; ii < movie.numFrames; ++ii) {
            movie.goTo(ii);
            recolorNamedLayers(movie, color);
        }
        movie.goTo(curFrame);
        return movie;
    }

    protected static function recolorImpl (disp :DisplayObject, color :uint, pred :Function) :void {
        if (disp is Quad) {
            Quad(disp).color = color;
        } else if (disp is DisplayObjectContainer) {
            var container :DisplayObjectContainer = DisplayObjectContainer(disp);
            var nn :int = container.numChildren;
            for (var ii :int = 0; ii < nn; ii++) {
                var child :DisplayObject = container.getChildAt(ii);
                if (pred(child)) {
                    recolorImpl(child, color, pred);
                }
            }
        }
    }

    protected static function HAS_RECOLOR_NAME (disp :DisplayObject) :Boolean {
        return disp.name == "recolor";
    }

    protected static function RECOLOR_ALL (disp :DisplayObject) :Boolean {
        return true;
    }
}
}
