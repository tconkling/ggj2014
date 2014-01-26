package ggj.rsrc {

import flash.display.Bitmap;

import flashbang.resource.Resource;
import flashbang.resource.ResourceLoader;

import starling.textures.Texture;

public class TextureResourceLoader extends ResourceLoader {
    public static const NAME :String = "name";

    public static const DATA :String = "data";

    public function TextureResourceLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        var name :String = requireLoadParam(NAME, String);
        var data :* = requireLoadParam(DATA);
        var bmp :Bitmap = data is Bitmap ? Bitmap(data) : new data();
        var tex :Texture = Texture.fromBitmap(bmp, false);
        bmp.bitmapData.dispose();
        succeed(new <Resource>[new TextureResource(name, tex)]);
    }
}
}
