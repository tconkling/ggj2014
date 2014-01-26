package ggj.rsrc {

import flashbang.core.Flashbang;
import flashbang.resource.Resource;

import starling.display.Image;
import starling.textures.Texture;

public class TextureResource extends Resource {
    public static function getImage (name :String) :Image {
        var rsrc :TextureResource = Flashbang.rsrcs.getResource(name);
        return rsrc == null ? null : rsrc.createImage();
    }

    public static function requireImage (name :String) :Image {
        return TextureResource(Flashbang.rsrcs.requireResource(name)).createImage();
    }

    public function TextureResource (name :String, tex :Texture) {
        super(name);
        _tex = tex;
    }

    public function createImage () :Image {
        return new Image(_tex);
    }

    protected var _tex :Texture;
}
}
