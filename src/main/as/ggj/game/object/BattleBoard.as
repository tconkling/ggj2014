package ggj.game.object {

import aspire.util.MathUtil;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Flashbang;

import ggj.GGJ;
import ggj.game.desc.TileType;
import ggj.game.view.BattleBoardView;
import ggj.grid.Grid;

public class BattleBoard extends BattleObject
{
    public function BattleBoard () {
        _tiles = new Grid(GGJ.GRID_WIDTH, GGJ.GRID_HEIGHT);
        for (var yy :int = 0; yy < _tiles.height; ++yy) {
            for (var xx :int = 0; xx < _tiles.width; ++xx) {
                _tiles.setCellAt(xx, yy, new Tile(xx, yy, null));
            }
        }

        const PLATFORMS :Array = [
            0, 6,
            1, 6,
            2, 6,
            3, 6,
            4, 6,
            5, 6,

            3, 3,
            4, 3,
            5, 3,
            6, 3,
            7, 3
        ];

        for (var ii :int = 0; ii < PLATFORMS.length; ii += 2) {
            getTile(PLATFORMS[ii], PLATFORMS[ii+1]).type = TileType.STONE;
        }
    }

    override protected function added () :void {
        super.added();
        _view = new BattleBoardView(this, new Point(Flashbang.stageWidth, Flashbang.stageHeight));
        addObject(_view, _ctx.boardLayer);
    }

    public function getCollisions (bounds :Rectangle, lastBounds :Rectangle, out :Point = null) :Point {
        out = (out || new Point());
        out.setTo(bounds.x, bounds.y);

        var xMin :int = Math.ceil(bounds.left);
        var xMax :int = Math.floor(bounds.right);
        var yMin :int = Math.ceil(bounds.top);
        var yMax :int = Math.floor(bounds.bottom);

        xMin = MathUtil.clamp(xMin, 0, this.width - 1);
        xMax = MathUtil.clamp(xMax, xMin, this.width - 1);
        yMin = MathUtil.clamp(yMin, 0, this.height - 1);
        yMax = MathUtil.clamp(yMax, yMin, this.height - 1);

        var xx :int;
        var yy :int;
        var tile :Tile;

        if (bounds.left < lastBounds.left) {
            // moving left
            xx = xMin;
            for (yy = yMin; yy <= yMax; ++yy) {
                tile = getTile(xx, yy);
                if (tile.type != null) {
                    out.x = xx + 1;
                    break;
                }
            }

        } else if (bounds.right > lastBounds.right) {
            // moving right
            xx = xMax;
            for (yy = yMin; yy <= yMax; ++yy) {
                tile = getTile(xx, yy);
                if (tile.type != null) {
                    out.x = xx - bounds.width;
                    break;
                }
            }
        }

        if (bounds.top < lastBounds.top) {
            // moving up
            yy = yMin;
            for (xx = xMin; xx <= xMax; ++xx) {
                tile = getTile(xx, yy);
                if (tile.type != null) {
                    out.y = yy + 1;
                    break;
                }
            }

        } else if (bounds.bottom > lastBounds.bottom) {
            // moving down
            yy = yMax;
            for (xx = xMin; xx <= xMax; ++xx) {
                tile = getTile(xx, yy);
                if (tile.type != null) {
                    out.y = yy - bounds.height;
                    break;
                }
            }
        }

        return out;
    }

    public function get view () :BattleBoardView {
        return _view;
    }

    public function get width () :int {
        return _tiles.width;
    }

    public function get height () :int {
        return _tiles.height;
    }

    public function get pxWidth () :Number {
        return GGJ.TILE_SIZE_PX * this.width;
    }

    public function get pxHeight () :Number {
        return GGJ.TILE_SIZE_PX * this.height;
    }

    public function getTile (x :int, y :int) :Tile {
        return _tiles.cellAt(x, y);
    }

    public function getTileAtIdx (idx :int) :Tile {
        return _tiles.cellAtIdx(idx);
    }

    public function isValidLoc (x :int, y :int) :Boolean {
        return _tiles.validLoc(x, y);
    }

    override public function get isSingleton () :Boolean {
        return true;
    }

    protected var _tiles :Grid;

    protected var _view :BattleBoardView;
}
}
