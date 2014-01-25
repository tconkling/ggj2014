//
// Global Game Jam 2014

package ggj.game.desc {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.prop.IntProp;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableBoardDesc extends MutableTome implements BoardDesc
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableBoardDesc (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get width () :int { return _width.value; }
    public function set width (val :int) :void { _width.value = val; }
    public function get height () :int { return _height.value; }
    public function set height (val :int) :void { _height.value = val; }
    public function get tiles () :Array { return _tiles.value; }
    public function set tiles (val :Array) :void { _tiles.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _width, _height, _tiles, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_widthSpec = new PropSpec("width", { "min": 1.0 }, [ int, ]);
            s_heightSpec = new PropSpec("height", { "min": 1.0 }, [ int, ]);
            s_tilesSpec = new PropSpec("tiles", null, [ Array, MutableTileDesc, ]);
        }
        _width = new IntProp(this, s_widthSpec);
        _height = new IntProp(this, s_heightSpec);
        _tiles = new ObjectProp(this, s_tilesSpec);
    }

    protected var _width :IntProp;
    protected var _height :IntProp;
    protected var _tiles :ObjectProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_widthSpec :PropSpec;
    private static var s_heightSpec :PropSpec;
    private static var s_tilesSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
