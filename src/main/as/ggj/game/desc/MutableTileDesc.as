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
public class MutableTileDesc extends MutableTome implements TileDesc
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableTileDesc (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get x () :int { return _x.value; }
    public function set x (val :int) :void { _x.value = val; }
    public function get y () :int { return _y.value; }
    public function set y (val :int) :void { _y.value = val; }
    public function get type () :TileType { return _type.value; }
    public function set type (val :TileType) :void { _type.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _x, _y, _type, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_xSpec = new PropSpec("x", { "min": 0.0 }, [ int, ]);
            s_ySpec = new PropSpec("y", { "min": 0.0 }, [ int, ]);
            s_typeSpec = new PropSpec("type", { "default": "STONE" }, [ TileType, ]);
        }
        _x = new IntProp(this, s_xSpec);
        _y = new IntProp(this, s_ySpec);
        _type = new ObjectProp(this, s_typeSpec);
    }

    protected var _x :IntProp;
    protected var _y :IntProp;
    protected var _type :ObjectProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_xSpec :PropSpec;
    private static var s_ySpec :PropSpec;
    private static var s_typeSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
