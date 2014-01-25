package ggj.game.object {

import flash.geom.Point;

import flashbang.core.Flashbang;

import ggj.GGJ;
import ggj.game.view.BattleBoardView;
import ggj.grid.Grid;

public class BattleBoard extends BattleObject
{
    public function BattleBoard () {
        _tiles = new Grid(GGJ.GRID_WIDTH, GGJ.GRID_HEIGHT);
        for (var yy :int = 0; yy < _tiles.height; ++yy) {
            for (var xx :int = 0; xx < _tiles.width; ++xx) {
                _tiles.setCellAt(xx, yy, new Tile(xx, yy, TileType.STONE));
            }
        }
    }

    override protected function added () :void {
        super.added();
        _view = new BattleBoardView(this, new Point(Flashbang.stageWidth, Flashbang.stageHeight));
        addObject(_view, _ctx.boardLayer);
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
