package ggj.game.object {

import aspire.util.Log;
import aspire.util.MathUtil;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Flashbang;

import ggj.GGJ;
import ggj.game.desc.BoardDesc;
import ggj.game.desc.PlayerColor;
import ggj.game.desc.TileDesc;
import ggj.game.desc.TileType;
import ggj.game.view.BattleBoardView;
import ggj.grid.Grid;

public class BattleBoard extends BattleObject
{
    public function BattleBoard (desc :BoardDesc, color :PlayerColor) {
        _color = color;
        _tiles = new Grid(desc.width, desc.height);
        for (var yy :int = 0; yy < _tiles.height; ++yy) {
            for (var xx :int = 0; xx < _tiles.width; ++xx) {
                _tiles.setCellAt(xx, yy, new Tile(xx, yy, TileType.EMPTY));
            }
        }
        for each (var tileDesc :TileDesc in desc.tiles) {
            var tile :Tile = getTile(tileDesc.x, tileDesc.y);
            tile.type = tileDesc.type;
            if (tileDesc.type == TileType.SPAWN) {
                _spawnTile = tile;
            }
        }

        if (_spawnTile == null) {
            log.warning("No spawn tile on this board");
            _spawnTile = _tiles.cellAtIdx(0);
        }
    }

    public function get spawnTile () :Tile {
        return _spawnTile;
    }

    override protected function added () :void {
        super.added();
        _view = new BattleBoardView(this, new Point(Flashbang.stageWidth, Flashbang.stageHeight),
            _color);
        addObject(_view, _ctx.boardLayer);
    }

    /** Return true if the given bounds intersects a tile of the given type */
    public function intersectsTile (bounds :Rectangle, tileType :TileType) :Boolean {
        var rightAligned :Boolean = (bounds.right == Math.floor(bounds.right));
        var xMin :int = Math.floor(bounds.left);
        var xMax :int = (rightAligned ? Math.floor(bounds.right - 1) : Math.floor(bounds.right));
        xMin = MathUtil.clamp(xMin, 0, this.width - 1);
        xMax = MathUtil.clamp(xMax, xMin, this.width - 1);

        var bottomAligned :Boolean = (bounds.bottom == Math.floor(bounds.bottom));
        var yMin :int = Math.floor(bounds.top);
        var yMax :int = (bottomAligned ? Math.floor(bounds.bottom - 1) : Math.floor(bounds.bottom));
        yMin = MathUtil.clamp(yMin, 0, this.height - 1);
        yMax = MathUtil.clamp(yMax, yMin, this.height - 1);

        for (var xx :int = xMin; xx <= xMax; ++xx) {
            for (var yy :int = yMin; yy <= yMax; ++yy) {
                if (getTile(xx, yy).type == tileType) {
                    return true;
                }
            }
        }

        return false;
    }

    public function getCollisions (bounds :Rectangle, lastBounds :Rectangle, vertical :Boolean, out :Collision = null) :Collision {
        var rightAligned :Boolean = (bounds.right == Math.floor(bounds.right));
        var xMin :int = Math.floor(bounds.left);
        var xMax :int = (rightAligned ? Math.floor(bounds.right - 1) : Math.floor(bounds.right));
        xMin = MathUtil.clamp(xMin, 0, this.width - 1);
        xMax = MathUtil.clamp(xMax, xMin, this.width - 1);

        var bottomAligned :Boolean = (bounds.bottom == Math.floor(bounds.bottom));
        var yMin :int = Math.floor(bounds.top);
        var yMax :int = (bottomAligned ? Math.floor(bounds.bottom - 1) : Math.floor(bounds.bottom));
        yMin = MathUtil.clamp(yMin, 0, this.height - 1);
        yMax = MathUtil.clamp(yMax, yMin, this.height - 1);

        var xx :int;
        var yy :int;
        var tile :Tile;

        if (!vertical) {
            // CHECK HORIZONTAL
            if (bounds.left < lastBounds.left) {
                // moving left
                xx = xMin;
                for (yy = yMin; yy <= yMax; ++yy) {
                    tile = getTile(xx, yy);
                    if (tile.type.collides) {
                        return (out || new Collision()).set(xx + 1, tile);
                    }
                }

            } else if (bounds.right > lastBounds.right) {
                // moving right
                xx = xMax;
                for (yy = yMin; yy <= yMax; ++yy) {
                    tile = getTile(xx, yy);
                    if (tile.type.collides) {
                        return (out || new Collision).set(xx - bounds.width, tile);
                    }
                }
            }

        } else {
            /// CHECK VERTICAL
            if (bounds.top < lastBounds.top) {
                // moving up
                yy = yMin;
                for (xx = xMin; xx <= xMax; ++xx) {
                    tile = getTile(xx, yy);
                    if (tile.type.collides) {
                        return (out || new Collision).set(yy + 1, tile);
                    }
                }

            } else if (bounds.bottom > lastBounds.bottom) {
                // moving down
                yy = yMax;
                for (xx = xMin; xx <= xMax; ++xx) {
                    tile = getTile(xx, yy);
                    if (tile.type.collides) {
                        return (out || new Collision()).set(yy - bounds.height, tile);
                    }
                }
            }
        }

        return null;
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

    protected var _color :PlayerColor;
    protected var _tiles :Grid;
    protected var _spawnTile :Tile;

    protected var _view :BattleBoardView;

    protected static const log :Log = Log.getLog(BattleBoard);
}
}
