package ggj.game.object {

public class Tile
{
    public function Tile (x :int, y :int, type :TileType) {
        _type = type;
        _x = x;
        _y = y;
    }

    public function get type () :TileType {
        return _type;
    }

    public function get x () :int {
        return _x;
    }

    public function get y () :int {
        return _y;
    }

    public function toString () :String {
        return "Tile (" + _x + "," + _y + ")";
    }

    protected var _x :int;
    protected var _y :int;
    protected var _type :TileType;
}
}
