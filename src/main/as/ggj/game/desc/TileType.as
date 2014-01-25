package ggj.game.desc {

import aspire.util.Enum;

public final class TileType extends Enum
{
    public static const STONE :TileType = new TileType("STONE", "game/img_tile_stone");
    public static const SPIKE :TileType = new TileType("SPIKE", "game/img_tile_skull");
    finishedEnumerating(TileType);

    public static function values () :Array {
        return Enum.values(TileType);
    }

    public static function valueOf (name :String) :TileType {
        return Enum.valueOf(TileType, name) as TileType;
    }

    public function get imageName () :String {
        return _imageName;
    }

    public function TileType (name :String, imageName :String) {
        super(name);
        _imageName = imageName;
    }

    protected var _imageName :String;
}
}

