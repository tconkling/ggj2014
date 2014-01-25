//
// ggj

package ggj.grid {

import aspire.geom.Vector2;
import aspire.util.MathUtil;
import aspire.util.Preconditions;

import flash.geom.Rectangle;

import flashbang.objects.SpriteObject;

import starling.display.DisplayObject;

public class TileGridView extends SpriteObject
{
    public function TileGridView (grid :Grid, tileSizePx :Vector2, viewCreator :Function) {
        super(null, null);
        _grid = grid;
        _tileSizePx = _tileSizePx.clone();
        _viewCreator = viewCreator;
        _viewBounds = new Rectangle(NaN, NaN, NaN, NaN);
        _tileViews = new Grid(grid.width, grid.height);
    }

    public function setViewBounds (x :Number, y :Number, w :Number, h :Number) :void {
        if (_viewBounds.x == x && _viewBounds.y == y && _viewBounds.width == w &&
            _viewBounds.height == h) {
            return;
        }

        var old :Rectangle = _viewBounds.clone();
        _viewBounds.setTo(x, y, w, h);

        var minX :int = Math.min(_viewBounds.left, old.left);
        var maxX :int = Math.max(_viewBounds.right, old.right);
        var minY :int = Math.min(_viewBounds.top, old.top);
        var maxY :int = Math.max(_viewBounds.bottom, old.bottom);

        minX = MathUtil.clamp(minX, 0, _grid.width - 1);
        maxX = MathUtil.clamp(maxX, 0, _grid.width - 1);
        minY = MathUtil.clamp(minY, 0, _grid.height - 1);
        maxY = MathUtil.clamp(maxY, 0, _grid.height - 1);

        for (var yy :int = minY; yy <= maxY; ++yy) {
            for (var xx :int = minX; xx <= maxX; ++xx) {
                var wasVisible :Boolean = viewBoundsContainsTile(old, xx, yy);
                var isVisible :Boolean = viewBoundsContainsTile(_viewBounds, xx, yy);
                if (wasVisible && !isVisible) {
                    eraseTileAt(xx, yy);
                } else if (!wasVisible && isVisible) {
                    drawTileAt(xx, yy);
                }
            }
        }
    }

    protected function drawTileAt (xx :int, yy :int) :void {
        drawTileAtIdx(_grid.getIdx(xx, yy));
    }

    protected function drawTileAtIdx (idx :int) :void {
        Preconditions.checkState(_tileViews.cellAtIdx(idx) == null);
        var tile :Object = _grid.cellAtIdx(idx);

        // build the new tile
        if (tile != null) {
            var xx :int = _grid.idxToX(idx);
            var yy :int = _grid.idxToY(idx);
            var tileView :DisplayObject = _viewCreator(xx, yy, tile);
            tileView.x = xx * _tileSizePx.x;
            tileView.y = yy * _tileSizePx.y;
            _sprite.addChild(tileView);

            _tileViews.setCellAtIdx(idx, tileView);
        }
    }

    protected function eraseTileAt (xx :int, yy :int) :void {
        eraseTileAtIdx(_grid.getIdx(xx, yy));
    }

    protected function eraseTileAtIdx (idx :int) :void {
        var tileView :DisplayObject = _tileViews.cellAtIdx(idx);
        if (tileView != null) {
            tileView.removeFromParent(true);
            _tileViews.setCellAtIdx(idx, null);
        }
    }

    protected static function viewBoundsContainsTile (bounds :Rectangle, xx :int, yy :int) :Boolean {
        // Floor all the values

        return !isNaN(bounds.left) &&
            !isNaN(bounds.right) &&
            xx >= int(bounds.left) &&
            xx <= int(bounds.right) &&
            yy >= int(bounds.top) &&
            yy <= int(bounds.bottom);
    }

    protected var _grid :Grid;
    protected var _tileSizePx :Vector2;
    protected var _viewBounds :Rectangle;

    protected var _tileViews :Grid;
    protected var _viewCreator :Function;
}
}
