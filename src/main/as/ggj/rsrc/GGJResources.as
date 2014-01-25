//
// ggj-core

package ggj.rsrc {

import aspire.util.FileUtil;

import flash.filesystem.File;

import ggj.GGJ;

public class GGJResources
{
    public function GGJResources (rootDir :File) {
        _root = rootDir;
    }

    // gamedata
    public function get tome () :Object {
        return { type: "microtome", name: "tome",
            data: [ url("tome/" + GAMEDATA_NAME) ] };
    }

    // gfx
    public function get gameFlump () :Object {
        return { type: "flump", name: "game", data: url("flump/game.zip") };
    }

    // fonts
    public function get futura50Font () :Object {
        return {
            type: "font", name: "futura50",
            xmlData: url(withScale("fonts/Futura50.fnt")),
            textureData: url(withScale("fonts/Futura50.png")),
            scale: GGJ.textureScale
        };
    }

    public function get futura25Font () :Object {
        return {
            type: "font", name: "futura25",
            xmlData: url(withScale("fonts/Futura25.fnt")),
            textureData: url(withScale("fonts/Futura25.png")),
            scale: GGJ.textureScale
        };
    }

    public function get helvetica12Font () :Object {
        return {
            type: "font", name: "helvetica12",
            xmlData: url(withScale("fonts/Helvetica12.fnt")),
            textureData: url(withScale("fonts/Helvetica12.png")),
            scale: GGJ.textureScale
        };
    }

    public function get helvetica24Font () :Object {
        return {
            type: "font", name: "helvetica24",
            xmlData: url(withScale("fonts/Helvetica24.fnt")),
            textureData: url(withScale("fonts/Helvetica24.png")),
            scale: GGJ.textureScale
        };
    }

    protected function url (path :String) :String {
        return _root.resolvePath(path).url;
    }

    protected static function withScale (filename :String) :String {
        if (GGJ.textureScale != 1) {
            const ext :String = FileUtil.getDotSuffix(filename);
            filename = FileUtil.stripDotSuffix(filename) + "@" + GGJ.textureScale + "x." + ext;
        }
        return filename;
    }

    protected var _root :File;

    protected static const GAMEDATA_NAME :String = "game.xml";
}
}

