package ggj.game.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;
import flashbang.objects.SpriteObject;

import ggj.GGJ;
import ggj.game.desc.PlayerColor;
import ggj.rsrc.TextureResource;

import react.SignalView;
import react.UnitSignal;

import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

public class ActorAnimation extends SpriteObject implements Updatable {
    public static function createIdle (color :PlayerColor) :ActorAnimation {
        return new ActorAnimation(color.idleOffset, 5.0, 11);
    }

    public static function createRun (color :PlayerColor) :ActorAnimation {
        return new ActorAnimation(color.runOffset, 15.0, 9);
    }

    public static function createJump (color :PlayerColor, fps :Number) :ActorAnimation {
        return new ActorAnimation(color.jumpOffset, fps, 11, false);
    }

    public static function createDeath (color :PlayerColor) :ActorAnimation {
        return new ActorAnimation(color.deathOffset, 15.0, 8, false);
    }

    public function ActorAnimation (offset :Point, fps :Number, numFrames :int,
            loops :Boolean = true) {
        _offset = offset;
        _spf = 1 / fps;
        _numFrames = numFrames;
        _loops = loops;
    }

    public function get visible () :Boolean {
        return _visible;
    }

    public function set visible (value :Boolean) :void {
        if (_visible == value) return;
        _sprite.getChildAt(_idx).visible = _visible = value;
        if (!_visible) _idx = 0; // reset index when going invisible
    }

    public function get done () :SignalView {
        if (_doneSignal == null) {
            _doneSignal = new UnitSignal();
        }
        return _doneSignal;
    }

    public function update (dt :Number) :void {
        if (!_visible) return;
        _elapsed += dt;
        while (_elapsed > _spf) {
            _elapsed -= _spf;
            incrementFrame();
        }
    }

    override protected function added () :void {
        var tex :Texture = TextureResource.requireImage("player").texture;
        var size :int = GGJ.ACTOR_SHEET_TILE_PX;
        for (var ii :int = 0; ii < _numFrames; ii++) {
            var x :int = (_offset.x + ii) * size;
            var y :int = _offset.y * size;
            var img :Image = new Image(Texture.fromTexture(tex, new Rectangle(x, y, size, size)));
            img.scaleX = img.scaleY = 2.0;
            img.x = -GGJ.ACTOR_SHEET_TILE_PX;
            img.y = -GGJ.ACTOR_SHEET_TILE_PX * 2;
            img.smoothing = TextureSmoothing.NONE;
            _sprite.addChild(img);
            img.visible = false;
        }
    }

    protected function incrementFrame () :void {
        if (_idx == _sprite.numChildren - 1 && _doneSignal != null && !_signaledDone) {
            _signaledDone = true;
            _doneSignal.emit();
        }
        if (!_loops && _idx == _sprite.numChildren - 1) return;

        _signaledDone = false; // don't prevent future done dispatches if we're looping
        _sprite.getChildAt(_idx).visible = false;
        _idx = (_idx + 1) % _sprite.numChildren;
        _sprite.getChildAt(_idx).visible = true;
    }

    protected var _offset :Point;
    protected var _spf :Number;
    protected var _numFrames :int;
    protected var _loops :Boolean;
    protected var _idx :int = 0;
    protected var _elapsed :Number = 0;
    protected var _visible :Boolean;
    protected var _doneSignal :UnitSignal;
    protected var _signaledDone :Boolean;
}
}
