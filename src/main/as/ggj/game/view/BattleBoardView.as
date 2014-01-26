//
// aciv

package ggj.game.view {

import aspire.util.Comparators;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.MathUtil;

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.resource.ImageResource;
import flashbang.util.Easing;

import ggj.GGJ;
import ggj.game.desc.PlayerColor;
import ggj.game.desc.TileType;
import ggj.game.object.BattleBoard;
import ggj.game.object.Tile;
import ggj.grid.BoardView;
import ggj.grid.Grid;
import ggj.grid.ScrollTask;

import react.Promise;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

public class BattleBoardView extends BoardView
{
    public const overlayLayer :Sprite = new Sprite();

    public function BattleBoardView (board :BattleBoard, viewSizePx :Point, color :PlayerColor) {
        super(new Point(GGJ.TILE_SIZE_PX, GGJ.TILE_SIZE_PX), viewSizePx);

        _board = board;

        _root.addChild(_tileLayer);
        _root.addChild(overlayLayer);

        _tiles = new Grid(board.width, board.height);

        _lastViewBounds = new Rectangle(0, 0, _board.width, _board.height);

        _color = color;
        _tileSheet = ImageResource.require("game/tilesheet").texture;

        // create tile sprites
        const scale :Number = GGJ.TILE_SIZE_PX / GGJ.TILE_SHEET_TILE_PX;
        for (var yy :int = 0; yy < _board.height; ++yy) {
            for (var xx :int = 0; xx < _board.width; ++xx) {
                var tile :Tile = _board.getTile(xx, yy);
                var xLoc :Number = xx * _tileSizePx.x;
                var yLoc :Number = yy * _tileSizePx.y;
                var tileSprite :Sprite = new Sprite();
                tileSprite.x = xLoc;
                tileSprite.y = yLoc;
                tileSprite.scaleX = tileSprite.scaleY = scale;
                _tileLayer.addChild(tileSprite);
                _tiles.setCellAt(xx, yy, tileSprite);

                updateTileView(tile);
            }
        }
    }

    public function updateView () :void {
        if (!_lastViewBounds.equals(this.viewBounds)) {
            tilesUpdated();

            updateTileVisibility(this.viewBounds, _lastViewBounds);
            _lastViewBounds.copyFrom(this.viewBounds);
        }

        if (_tilesUpdated) {
            _tileLayer.flatten();
            _tilesUpdated = false;
        }
    }

    protected function updateTileVisibility (newViewBounds :Rectangle, oldViewBounds :Rectangle) :void {
        var minX :int = MathUtil.min(newViewBounds.left, oldViewBounds.left);
        var maxX :int = MathUtil.max(newViewBounds.right, oldViewBounds.right);
        var minY :int = MathUtil.min(newViewBounds.top, oldViewBounds.top);
        var maxY :int = MathUtil.max(newViewBounds.bottom, oldViewBounds.bottom);

        minX = MathUtil.clamp(minX, 0, _board.width - 1);
        maxX = MathUtil.clamp(maxX, 0, _board.width - 1);
        minY = MathUtil.clamp(minY, 0, _board.height - 1);
        maxY = MathUtil.clamp(maxY, 0, _board.height - 1);

        for (var yy :int = minY; yy <= maxY; ++yy) {
            for (var xx :int = minX; xx <= maxX; ++xx) {
                var wasVisible :Boolean = viewBoundsContains(oldViewBounds, xx, yy);
                var isVisible :Boolean = viewBoundsContains(newViewBounds, xx, yy);
                if (wasVisible == isVisible) {
                    continue;
                }

                var idx :int = _tiles.getIdx(xx, yy);
                var tileView :DisplayObject = _tiles.cellAtIdx(idx);
                tileView.visible = isVisible;
            }
        }
    }

    public function updateTileView (tile :Tile) :void {
        var tileSprite :Sprite = _tiles.cellAt(tile.x, tile.y);
        tileSprite.removeChildren(0, -1, true);
        if (tile.type != TileType.EMPTY) {
            var img :Image = new Image(getTexture(tile.type));
            img.smoothing = TextureSmoothing.NONE;
            tileSprite.addChild(img);
        }
        tilesUpdated();
    }

    protected static function viewBoundsContains (bounds :Rectangle, xx :int, yy :int) :Boolean {
        // floor all the values
        return (xx >= int(bounds.left) &&
            xx <= int(bounds.right) &&
            yy >= int(bounds.top) &&
            yy <= int(bounds.bottom));
    }

    public function getTileAt (boardLoc :Point) :Tile {
        return (_board.isValidLoc(boardLoc.x, boardLoc.y) ?
            _board.getTile(boardLoc.x, boardLoc.y) :
            null);
    }

    public function viewToTile (viewLoc :Point) :Tile {
        return getTileAt(viewToBoard(viewLoc, P));
    }

    public function tileToView (tile :Tile, out :Point = null) :Point {
        P.setTo(tile.x, tile.y);
        return boardToView(P, out);
    }

    public function globalToTile (globalLoc :Point) :Tile {
        return getTileAt(globalToBoard(globalLoc, P));
    }

    public function tileToGlobal (tile :Tile, out :Point = null) :Point {
        P.setTo(tile.x, tile.y);
        return boardToGlobal(P, out);
    }

    public function getEntityViewLoc (x :Number, y :Number, out :Point = null) :Point {
        P.setTo(x + 0.5, y + 1);
        return boardToView(P, out);
    }

    /** Immediately moves the board camera so that the given board location is near the center of the screen */
    public function jumpTo (x :Number, y :Number) :void {
        removeNamedObjects(PAN_ANIM);
        var scrollLoc :Point = getScrollLocFor(x, y, 0, 0, P);
        setScroll(scrollLoc.x, scrollLoc.y);
    }

    protected function tilesUpdated () :void {
        _tileLayer.unflatten();
        _tilesUpdated = true;
    }

    override public function setScroll (x :Number, y :Number) :void {
        // clamp X
        const boardSizeX :Number = _board.width * _tileSizePx.x * this.zoom;
        if (boardSizeX < _viewSizePx.x) {
            x = -(_viewSizePx.x - boardSizeX) * 0.5;
        } else {
            x = MathUtil.clamp(x, 0, boardSizeX - _viewSizePx.x);
        }

        // clamp Y
        const boardSizeY :Number = _board.height * _tileSizePx.y * this.zoom;
        if (boardSizeY < _viewSizePx.y) {
            y = -(_viewSizePx.y - boardSizeY) * 0.5;
        } else {
            y = MathUtil.clamp(y, 0, boardSizeY - _viewSizePx.y);
        }

        super.setScroll(x, y);
    }

    protected function panTo (x :Number, y :Number, p :Promise = null) :void {
        removeNamedObjects(PAN_ANIM);
        if (x != this.scrollX || y != this.scrollY) {
            var task :ScrollTask = new ScrollTask(x, y, 0.5, Easing.easeOut);
            if (p != null) {
                task.destroyed.connect(p.succeed);
            }
            addNamedObject(PAN_ANIM, task);
        } else if (p != null) {
            p.succeed();
        }
    }

    /** Returns the camera location so that the given board location is near the center of the screen */
    protected function getScrollLocFor (x :Number, y :Number, xTolerance :Number,
                                        yTolerance :Number, p :Point = null) :Point {

        // convert to screen coords
        const zoom :Number = this.zoom;
        x *= _tileSizePx.x * zoom;
        y *= _tileSizePx.y * zoom;
        // center x,y on the screen
        x -= _viewSizePx.x * 0.5 * zoom;
        y -= _viewSizePx.y * 0.5 * zoom;

        const minX :Number = 0;
        const minY :Number = 0;
        const maxX :Number = (_board.width * _tileSizePx.x) - _viewSizePx.x;
        const maxY :Number = (_board.height * _tileSizePx.y) - _viewSizePx.y;

        // we want the camera to fall somewhere in this rectangle
        const left :Number = MathUtil.clamp(x - xTolerance, minX, maxX);
        const right :Number = MathUtil.clamp(x + xTolerance, minX, maxX);
        const top :Number = MathUtil.clamp(y - yTolerance, minY, maxY);
        const bottom :Number = MathUtil.clamp(y + yTolerance, minY, maxY);

        const targetX :Number = MathUtil.clamp(this.scrollX, left, right);
        const targetY :Number = MathUtil.clamp(this.scrollY, top, bottom);

        if (p == null) {
            p = new Point(targetX, targetY);
        } else {
            p.setTo(targetX, targetY);
        }
        return p;
    }

    protected static function depthCompare (a :DisplayObject, b :DisplayObject) :Number {
        return Comparators.compareNumbers(a.y, b.y);
    }

    protected function getTexture (type :TileType) :Texture {
        var tex :Texture = _tileTextures.get(type);
        if (tex == null) {
            var loc :Point = type.getTileCoordinates(_color);
            tex = Texture.fromTexture(_tileSheet,
                new Rectangle(loc.x, loc.y, GGJ.TILE_SHEET_TILE_PX, GGJ.TILE_SHEET_TILE_PX));
            _tileTextures.put(type, tex);
        }
        return tex;
    }

    protected var _board :BattleBoard;
    protected var _tiles :Grid;

    protected var _tilesUpdated :Boolean;

    protected var _lastViewBounds :Rectangle;

    protected var _tileSheet :Texture;
    protected var _color :PlayerColor;
    protected var _tileTextures :Map = Maps.newMapOf(TileType);

    protected const _tileLayer :Sprite = new Sprite();

    protected static const P :Point = new Point();
    protected static const R :Rectangle = new Rectangle();

    protected static const PAN_ANIM :String = "ZoomAnim";
}
}
