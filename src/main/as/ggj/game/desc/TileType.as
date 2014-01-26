package ggj.game.desc {

import aspire.util.Enum;

import flash.geom.Point;

import ggj.GGJ;

public final class TileType extends Enum
{
    // floor/wall/ceiling tile types
    // block (closed in all directions)
    public static const BLOCK :TileType = new TileType("BLOCK");
    // N/E/S/W = cardinal directions - only open directions included
    // dual direction
    public static const E :TileType = new TileType("E");
    public static const EW :TileType = new TileType("EW");
    public static const W :TileType = new TileType("W");
    public static const S :TileType = new TileType("S");
    public static const NS :TileType = new TileType("NS");
    public static const N :TileType = new TileType("N");
    // elbows
    public static const ES :TileType = new TileType("ES");
    public static const SW :TileType = new TileType("SW");
    public static const NE :TileType = new TileType("NE");
    public static const NW :TileType = new TileType("NW");
    // cross
    public static const NESW :TileType = new TileType("NESW");
    // Ts
    public static const ESW :TileType = new TileType("ESW");
    public static const NSW :TileType = new TileType("NSW");
    public static const NES :TileType = new TileType("NES");
    public static const NEW :TileType = new TileType("NEW");
    // horz broken
    public static const EW_BROKEN :TileType = new TileType("EW_BROKEN");
    // spikes
    public static const SPIKE_GROUND :TileType = new TileType("SPIKE_GROUND", false, true);
    public static const SPIKE_CEIL :TileType = new TileType("SPIKE_CEIL", false, true);
    // permanent block - guaranteed same in all maps, counts as ground
    public static const PERMANENT :TileType = new TileType("PERMANENT");
    // spawn and goal - not floor, the player can layer on top of them
    public static const SPAWN :TileType = new TileType("SPAWN", false);
    public static const GOAL :TileType = new TileType("GOAL", false);
    finishedEnumerating(TileType);

    public static function values () :Array {
        return Enum.values(TileType);
    }

    public static function valueOf (name :String) :TileType {
        return Enum.valueOf(TileType, name) as TileType;
    }

    public function getTileCoordinates (color :PlayerColor) :Point {
        var x :int;
        var y :int;
        switch (this) {
        case PERMANENT:
            y = 4;
            break;

        case GOAL:
            x = 1;
            y = 5;
            break;

        case SPAWN:
            y = 5;
            break;

        case SPIKE_GROUND:
            x = 1 + color.ordinal();
            y = 4;
            break;

        case SPIKE_CEIL:
            x = 5 + color.ordinal();
            y = 4;
            break;

        default:
            // all the floor tiles
            x = ordinal();
            y = color.ordinal();
        }

        return new Point(x * GGJ.TILE_SIZE_PX, y * GGJ.TILE_SIZE_PX);
    }

    public function get isFloor () :Boolean {
        return _isFloor;
    }

    public function get isSpike () :Boolean {
        return _isSpike;
    }

    public function TileType (name :String, isFloor :Boolean = true, isSpike :Boolean = false) {
        super(name);
        _isFloor = isFloor;
        _isSpike = isSpike;
    }

    protected var _isFloor :Boolean;
    protected var _isSpike :Boolean;
}
}

