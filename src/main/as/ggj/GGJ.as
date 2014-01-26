//
// ggj

package ggj {

import aspire.util.Randoms;

import ggj.rsrc.GGJResources;

public class GGJ
{
    /// Constants
    public static const DEBUG :Boolean = false;

    public static const WIN_SCORE :int = 5;
    public static const ACTOR_WIDTH :Number = 0.8;
    public static const ACTOR_HEIGHT :Number = 0.7;
    public static const FRAMERATE :Number = 1 / 60;
    public static const TILE_SIZE_PX :Number = 48;
    public static const TILE_SHEET_TILE_PX :Number = 24;
    public static const ACTOR_SHEET_TILE_PX :Number = 48;

    public static const RAND :Randoms = new Randoms();

    /** hard coded because we didn't get time to make it dynamic */
    public static const NUM_PLAYERS :int = 4;

    /// Singletons
    public static function get resourceParams () :GGJResources { return _resourceParams; }
    public static function get textureScale () :int { return _textureScale; }

    internal static function init (resourceParams :GGJResources, textureScale :int) :void {
        _resourceParams = resourceParams;
        _textureScale = textureScale;
    }

    protected static var _resourceParams :GGJResources;
    protected static var _textureScale :int;
}
}
