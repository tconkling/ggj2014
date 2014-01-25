//
// ggj

package ggj.grid {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.objects.SpriteObject;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Touch;

public class BoardView extends SpriteObject
{
    public function BoardView (tileSizePx :Point, viewSizePx :Point) {
        _tileSizePx = tileSizePx.clone();
        _viewSizePx = viewSizePx.clone();
        _sprite.addChild(_root);
    }

    /** Returns the board's viewBounds in board coordinates */
    public function get viewBounds () :Rectangle {
        if (_viewBoundsDirty) {
            var scaleX :Number = 1 / (this.zoom * _tileSizePx.x);
            var scaleY :Number = 1 / (this.zoom * _tileSizePx.y);
            _viewBounds.setTo(
                -_root.x * scaleX,
                -_root.y * scaleY,
                _viewSizePx.x * scaleX,
                _viewSizePx.y * scaleY);
            _viewBoundsDirty = false;
        }
        return _viewBounds;
    }

    public function get tileSizePx () :Point {
        return _tileSizePx;
    }

    public function get scrollX () :Number {
        return -_root.x;
    }

    public function get scrollY () :Number {
        return -_root.y;
    }

    public function set scrollX (val :Number) :void {
        setScroll(val, this.scrollY);
    }

    public function set scrollY (val :Number) :void {
        setScroll(this.scrollX, val);
    }

    public function get zoom () :Number {
        return _root.scaleX;
    }

    public function set zoom (val :Number) :void {
        if (val != zoom) {
            _root.scaleX = _root.scaleY = val;
            _viewBoundsDirty = true;
        }
    }

    /** Zoom, keeping the given anchor point in the same screen location post-zoom as it was
    * pre-zoom. The anchor point should be in global coordinates. */
    public function anchoredZoom (val :Number, anchorGlobal :Point) :void {
        if (val == this.zoom) {
            return;
        }

        // we want to change our scroll location so that
        // the given anchor point is in the same screen position
        // before and after the zoom

        var p :Point = _root.globalToLocal(anchorGlobal, P);

        this.zoom = val;

        p = _root.localToGlobal(p, P);
        setScroll(this.scrollX + p.x - anchorGlobal.x, this.scrollY + p.y - anchorGlobal.y);
    }

    public function setScroll (x :Number, y :Number) :void {
        _root.x = -x;
        _root.y = -y;
        _viewBoundsDirty = true;
    }

    public function viewToBoard (p :Point, out :Point = null) :Point {
        out = (out || new Point());
        out.setTo(int(p.x / _tileSizePx.x), int(p.y / _tileSizePx.y));
        return out;
    }

    public function boardToView (p :Point, out :Point = null) :Point {
        out = (out || new Point());
        out.setTo(p.x * _tileSizePx.x, p.y * _tileSizePx.y);
        return out;
    }

    public function boardToViewBounds (r :Rectangle, out :Rectangle = null) :Rectangle {
        out = (out || new Rectangle());
        out.setTo(
            r.x * _tileSizePx.x,
            r.y * _tileSizePx.y,
            r.width * _tileSizePx.x,
            r.height * _tileSizePx.y);
        return out;
    }

    public function globalToView (p :Point, out :Point = null) :Point {
        return this.objectRootLayer.globalToLocal(p, out);
    }

    public function viewToScreen (p :Point, out :Point = null) :Point {
        return this.objectRootLayer.localToGlobal(p, out);
    }

    public function globalToBoard (p :Point, out :Point = null) :Point {
        return viewToBoard(globalToView(p, out), out);
    }

    public function boardToGlobal (p :Point, out :Point = null) :Point {
        out = (out || new Point());
        return viewToScreen(boardToView(p, out), out);
    }

    public function touchToBoard (t :Touch, out :Point = null) :Point {
        P.setTo(t.globalX, t.globalY);
        return globalToBoard(P, out);
    }

    public function touchToView (t :Touch, out :Point = null) :Point {
        P.setTo(t.globalX, t.globalY);
        return globalToView(P, out);
    }

    public final function get viewRoot () :DisplayObject {
        return this.objectRootLayer;
    }

    protected function get objectRootLayer () :Sprite {
        return _root;
    }

    protected var _tileSizePx :Point;
    protected var _viewSizePx :Point;
    protected var _viewBounds :Rectangle = new Rectangle();
    protected var _viewBoundsDirty :Boolean;
    protected var _root :Sprite = new Sprite();

    // scratch objects
    protected static const P :Point = new Point();
}
}
