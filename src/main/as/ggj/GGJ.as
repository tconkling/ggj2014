//
// ggj

package ggj {

import ggj.rsrc.GGJResources;

public class GGJ
{
    /// Singletons
    public static function get resourceParams () :GGJResources { return _resourceParams; }
    public static function get textureScale () :int { return _textureScale; }

    internal static function init (resourceParams :GGJResources, textureScale :int) :void {
        _resourceParams = resourceParams;
        _textureScale = textureScale;
    }

    protected static var _resourceParams :GGJResources;
    protected static var _textureScale :int;

    protected static var _isMobile :Boolean;
}
}
