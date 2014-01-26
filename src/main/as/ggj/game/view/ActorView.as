package ggj.game.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;
import flashbang.util.DisplayUtil;

import ggj.game.object.Actor;

import starling.display.Quad;

public class ActorView extends BattleSpriteObject implements Updatable
{
    public function ActorView (actor :Actor) {
        _actor = actor;
    }

    override protected function added () :void {
        super.added();
        var bounds :Rectangle = _ctx.boardMgr.activeBoard.view.boardToViewBounds(_actor.bounds);

        _idle = new IdleAnimation(_actor.team.color);
        addObject(_idle, _sprite);
        _idle.display.x = bounds.width * 0.5;
        _idle.display.y = bounds.height;
        _idle.visible = true;

        _run = new RunAnimation(_actor.team.color);
        addObject(_run, _sprite);
        _run.display.x = bounds.width * 0.5;
        _run.display.y = bounds.height;

        var boundsView :Quad = DisplayUtil.fillRect(bounds.width, bounds.height, 0xffffff);
        boundsView.alpha = 0.1;
        _sprite.addChild(boundsView);
    }

    public function update (dt :Number) :void {
        var loc :Point = _ctx.boardMgr.activeBoard.view.boardToView(_actor.bounds.topLeft);
        if (loc.equals(new Point(_sprite.x, _sprite.y))) {
            _idle.visible = true;
        } else {
            _idle.visible = false;
            _sprite.x = loc.x;
            _sprite.y = loc.y;
        }
        _run.visible = !_idle.visible;
    }

    protected var _actor :Actor;
    protected var _idle :IdleAnimation;
    protected var _run :RunAnimation;
}
}

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;
import flashbang.objects.SpriteObject;

import ggj.GGJ;
import ggj.game.desc.PlayerColor;
import ggj.rsrc.TextureResource;

import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

class ActorAnimation extends SpriteObject implements Updatable {
    public function ActorAnimation (offset :Point, fps :Number,
            numFrames :int) {
        _offset = offset;
        _spf = 1 / fps;
        _numFrames = numFrames;
    }

    public function get visible () :Boolean {
        return _visible;
    }

    public function set visible (value :Boolean) :void {
        if (_visible == value) return;

        _sprite.getChildAt(_idx).visible = _visible = value;
        if (!_visible) _idx = 0; // reset index when going invisible
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
        _sprite.getChildAt(_idx).visible = false;
        _idx = (_idx + 1) % _sprite.numChildren;
        _sprite.getChildAt(_idx).visible = true;
    }

    protected var _offset :Point;
    protected var _spf :Number;
    protected var _numFrames :int;
    protected var _idx :int = 0;
    protected var _elapsed :Number = 0;
    protected var _visible :Boolean;
}

class IdleAnimation extends ActorAnimation {
    public function IdleAnimation (color :PlayerColor) {
        super(color.idleOffset, 5.0, 11);
    }
}

class RunAnimation extends ActorAnimation {
    public function RunAnimation (color :PlayerColor) {
        super(color.runOffset, 15.0, 9);
    }
}
