//
// ggj-core

package ggj.rsrc {

import ggj.GGJ;

// TODO: make static? Could be static as it currently stands.
public class GGJResources
{
    public function get tome () :Object {
        return { type: "microtome", name: "gameTome", data: [ GAMEDATA_TOME,
            BOARD_LAYOUT_1, BOARD_LAYOUT_2, BOARD_LAYOUT_3 ] };
    }

    // gfx
    public function get gameFlump () :Object {
        return { type: "flump", name: "game", data: FLUMP };
    }

    public function get player () :Object {
        return { type: "texture", name: "player", data: PLAYER };
    }

    // fonts
    public function get futura50Font () :Object {
        return {
            type: "font", name: "futura50",
            xmlData: withScale("FUTURA_50_FNT"),
            textureData: withScale("FUTURA_50_PNG"),
            scale: GGJ.textureScale
        };
    }

    public function get futura25Font () :Object {
        return {
            type: "font", name: "futura25",
            xmlData: withScale("FUTURA_25_FNT"),
            textureData: withScale("FUTURA_25_PNG"),
            scale: GGJ.textureScale
        };
    }

    public function get helvetica12Font () :Object {
        return {
            type: "font", name: "helvetica12",
            xmlData: withScale("HELVETICA_12_FNT"),
            textureData: withScale("HELVETICA_12_PNG"),
            scale: GGJ.textureScale
        };
    }

    public function get helvetica24Font () :Object {
        return {
            type: "font", name: "helvetica24",
            xmlData: withScale("HELVETICA_24_FNT"),
            textureData: withScale("HELVETICA_24_PNG"),
            scale: GGJ.textureScale
        };
    }

    protected static function withScale (filename :String) :Class {
        if (GGJ.textureScale != 1) {
            filename = filename + "_2X";
        }
        return Class(GGJResources[filename]);
    }

    [Embed(source="../../../../../rsrc/flump/game.zip", mimeType="application/octet-stream")]
    protected static const FLUMP :Class;

    [Embed(source="../../../../../rsrc/tome/game.xml", mimeType="application/octet-stream")]
    protected static const GAMEDATA_TOME :Class;
    [Embed(source="../../../../../rsrc/tome/rgby_layout_1.xml", mimeType="application/octet-stream")]
    protected static const BOARD_LAYOUT_1 :Class;
    [Embed(source="../../../../../rsrc/tome/rgby_layout_2.xml", mimeType="application/octet-stream")]
    protected static const BOARD_LAYOUT_2 :Class;
    [Embed(source="../../../../../rsrc/tome/rgby_layout_3.xml", mimeType="application/octet-stream")]
    protected static const BOARD_LAYOUT_3 :Class;

    [Embed(source="../../../../../rsrc/fonts/Futura25.fnt", mimeType="application/octet-stream")]
    protected static const FUTURA_25_FNT :Class;
    [Embed(source="../../../../../rsrc/fonts/Futura25.png", mimeType="application/octet-stream")]
    protected static const FUTURA_25_PNG :Class;
    [Embed(source="../../../../../rsrc/fonts/Futura50.fnt", mimeType="application/octet-stream")]
    protected static const FUTURA_50_FNT :Class;
    [Embed(source="../../../../../rsrc/fonts/Futura50.png", mimeType="application/octet-stream")]
    protected static const FUTURA_50_PNG :Class;
    [Embed(source="../../../../../rsrc/fonts/Helvetica12.fnt", mimeType="application/octet-stream")]
    protected static const HELVETICA_12_FNT :Class;
    [Embed(source="../../../../../rsrc/fonts/Helvetica12.png", mimeType="application/octet-stream")]
    protected static const HELVETICA_12_PNG :Class;
    [Embed(source="../../../../../rsrc/fonts/Helvetica24.fnt", mimeType="application/octet-stream")]
    protected static const HELVETICA_24_FNT :Class;
    [Embed(source="../../../../../rsrc/fonts/Helvetica24.png", mimeType="application/octet-stream")]
    protected static const HELVETICA_24_PNG :Class;

    [Embed(source="../../../../../rsrc/player.png")]
    protected static const PLAYER :Class;
}
}

