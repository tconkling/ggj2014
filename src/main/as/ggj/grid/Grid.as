//
// ggj

package ggj.grid {

import aspire.geom.Collisions;
import aspire.geom.PointI;
import aspire.geom.RectangleI;
import aspire.util.MathUtil;
import aspire.util.Preconditions;

import flash.geom.Rectangle;

import react.Signal;

public class Grid
{
    public const cellChanged :Signal = new Signal(int); // idx

    public function Grid (width :int, height :int) {
        Preconditions.checkArgument(width > 0 && height > 0);
        _width = width;
        _height = height;
        _cells = new Vector.<Object>(_width * _height, true);
    }

    /** The cells vector. Not a view! */
    public function get cells () :Vector.<Object> {
        return _cells;
    }

    public function get width () :int {
        return _width;
    }

    public function get height () :int {
        return _height;
    }

    /** Applies the given function to all cells on the given line.
     * Return 'true' from the function to stop iteration. */
    public function forCellsInLine (x1 :int, y1 :int, x2 :int, y2 :int, f :Function) :void {
        Collisions.getSupercoverLineIntersections(
            MathUtil.clamp(x1, 0, _width - 1), MathUtil.clamp(y1, 0, _height - 1),
            MathUtil.clamp(x2, 0, _width - 1), MathUtil.clamp(y2, 0, _height - 1),
            false, // cornersTouchAllNeighbors == false
            function (xx :int, yy :int) :Boolean {
                return f(cellAt(xx, yy));
            });
    }

    /** Applies the given function to all cells in the given rectangle.
     * Return 'true' from the function to stop iterating. */
    public function forCellsInRect (r :RectangleI, f :Function) :void {
        var yFrom :int = Math.max(r.top, 0);
        var yTo :int = Math.min(r.bottom, _height - 1);
        var xFrom :int = Math.max(r.left, 0);
        var xTo :int = Math.min(r.right, _width - 1);

        for (var yy :int = yFrom; yy <= yTo; ++yy) {
            for (var xx :int = xFrom; xx <= xTo; ++xx) {
                var result :Boolean = f(_cells[(yy * _width) + xx]) as Boolean;
                if (result) {
                    return;
                }
            }
        }
    }

    /** Applies the given function to all cells on the edge of the given rectangle.
     * Return 'true' from the function to stop iterating. */
    public function forCellsOnRectEdge (r :RectangleI, f :Function) :void {
        // offset yFrom and yTo so we don't double-check corner tiles
        var yFrom :int = Math.max(r.top, 0);
        var yTo :int = Math.min(r.bottom, _height - 1);
        var xFrom :int = Math.max(r.left, 0);
        var xTo :int = Math.min(r.right, _width - 1);

        var yy :int;
        var xx :int;
        var result :Boolean;

        // top
        yy = yFrom;
        for (xx = xFrom; xx <= xTo; ++xx) {
            result = f(_cells[(yy * _width) + xx]) as Boolean;
            if (result) {
                return;
            }
        }

        // bottom (ensure height > 1, else top == bottom)
        if (yTo - yFrom > 0) {
            yy = yTo;
            for (xx = xFrom; xx <= xTo; ++xx) {
                result = f(_cells[(yy * _width) + xx]) as Boolean;
                if (result) {
                    return;
                }
            }
        }

        // left
        xx = xFrom;
        for (yy = yFrom + 1; yy <= yTo - 1; ++yy) { // top and bottom of column already checked
            result = f(_cells[(yy * _width) + xx]) as Boolean;
            if (result) {
                return;
            }
        }

        // right (ensure width > 1, else left == right)
        if (xTo != xFrom) {
            xx = xTo;
            for (yy = yFrom + 1; yy <= yTo - 1; ++yy) { // top and bottom of column already checked
                result = f(_cells[(yy * _width) + xx]) as Boolean;
                if (result) {
                    return;
                }
            }
        }
    }

    /** Applies the given function to all cells within 'range' distance of the given x,y loc.
     * Return true from the function to stop iteration. */
    public function forCellsInManhattanRange (x :int, y :int, range :uint, f :Function) :void {
        var yFrom :int = Math.max(y - range, 0);
        var yTo :int = Math.min(y + range, _height - 1);
        var xFrom :int = Math.max(x - range, 0);
        var xTo :int = Math.min(x + range, _width - 1);

        for (var yy :int = yFrom; yy <= yTo; ++yy) {
            for (var xx :int = xFrom; xx <= xTo; ++xx) {
                if (Math.abs(xx - x) + Math.abs(yy - y) <= range && f(_cells[(yy * _width) + xx])) {
                    return;
                }
            }
        }
    }

    /** Applies the given function to all cells within 'range' distance of the given x,y loc.
     * Return true from the function to stop iteration. */
    public function forCellsInChessboardRange (x :int, y :int, range :uint, f :Function) :void {
        var yFrom :int = Math.max(y - range, 0);
        var yTo :int = Math.min(y + range, _height - 1);
        var xFrom :int = Math.max(x - range, 0);
        var xTo :int = Math.min(x + range, _width - 1);

        for (var yy :int = yFrom; yy <= yTo; ++yy) {
            for (var xx :int = xFrom; xx <= xTo; ++xx) {
                if (f(_cells[(yy * _width) + xx])) {
                    return;
                }
            }
        }
    }

    /** Applies the given function to all cells that intersect the given circle.
     * Return true from the function to stop iteration. */
    public function forCellsInCircle (x :Number, y :Number, radius :Number, f :Function) :void {
        var yFrom :int = Math.max(y - radius, 0);
        var yTo :int = Math.min(y + radius, _height - 1);
        var xFrom :int = Math.max(x - radius, 0);
        var xTo :int = Math.min(x + radius, _width - 1);

        var rSq :Number = radius * radius;

        for (var yy :int = yFrom; yy <= yTo; ++yy) {
            for (var xx :int = xFrom; xx <= xTo; ++xx) {
                var a :Number = xx - x;
                var b :Number = yy - y;
                if ((a * a + b * b) <= rSq && f(_cells[(yy * _width) + xx])) {
                    return;
                }
            }
        }
    }

    public function resize (newWidth :int, newHeight :int) :void {
        Preconditions.checkArgument(newWidth > 0 && newHeight > 0);
        var newCells :Vector.<Object> = new Vector.<Object>(newWidth * newHeight, true);
        for (var yy :int = 0; yy < Math.min(newHeight, _height); ++yy) {
            for (var xx :int = 0; xx < Math.min(newWidth, _width); ++xx) {
                var oldIdx :int = (yy * _width) + xx;
                var newIdx :int = (yy * newWidth) + xx;
                newCells[newIdx] = _cells[oldIdx];
            }
        }

        _cells = newCells;
        _width = newWidth;
        _height = newHeight;
    }

    public function rectIntersectsCell (r :Rectangle, cell :Object) :Boolean {
        if (r.right < 0 || r.left >= _width || r.bottom < 0 || r.top >= _height) {
            return false;
        }

        var xMin :int = Math.max(int(r.left), 0);
        var xMax :int = Math.min(int(r.right), _width - 1);
        var yMin :int = Math.max(int(r.top), 0);
        var yMax :int = Math.min(int(r.bottom), _height - 1);

        for (var yy :int = yMin; yy <= yMax; ++yy) {
            for (var xx :int = xMin; xx <= xMax; ++xx) {
                if (cellAt(xx, yy) == cell) {
                    return true;
                }
            }
        }

        return false;
    }

    public function cellAt (x :int, y :int) :* {
        return cellAtIdx(getIdx(x, y));
    }

    public function cellAtIdx (idx :int) : * {
        Preconditions.checkArgument(validIdx(idx));
        return _cells[idx];
    }

    public function setCellAt (x :int, y :int, cell :Object) :* {
        return setCellAtIdx(getIdx(x, y), cell);
    }

    public function setCellAtIdx (idx :int, cell :Object) :* {
        Preconditions.checkArgument(validIdx(idx));
        var old :Object = _cells[idx];
        _cells[idx] = cell;
        this.cellChanged.emit(idx);
        return old;
    }

    public function getIdx (x :int, y :int) :int {
        return (y * _width) + x;
    }

    public function idxToX (idx :int) :int {
        return (idx % _width);
    }

    public function idxToY (idx :int) :int {
        return (idx / _width);
    }

    public function idxToXY (idx :int, out :PointI = null) :PointI {
        var y :int = idx / _width;
        var x :int = idx - (y * _width);
        return (out == null ? new PointI(x, y) : out.set(x, y));
    }

    public function validLoc (x :int, y :int) :Boolean {
        return (x >= 0 && x < _width && y >= 0 && y < _height);
    }

    public function validIdx (idx :int) :Boolean {
        return (idx >= 0 && idx < _cells.length);
    }

    protected var _width :int;
    protected var _height :int;
    protected var _cells :Vector.<Object>;
}
}
