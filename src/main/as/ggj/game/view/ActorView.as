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

        var idle :IdleAnim = new IdleAnim(_actor.team.color);
        addObject(idle, _sprite);
        idle.display.x = bounds.width * 0.5;
        idle.display.y = bounds.height;
        idle.visible = true;

        var boundsView :Quad = DisplayUtil.fillRect(bounds.width, bounds.height, 0xffffff);
        boundsView.alpha = 0.1;
        _sprite.addChild(boundsView);
    }

    public function update (dt :Number) :void {
        var loc :Point = _ctx.boardMgr.activeBoard.view.boardToView(_actor.bounds.topLeft);
        _sprite.x = loc.x;
        _sprite.y = loc.y;
    }

    protected var _actor :Actor;
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

class IdleAnim extends SpriteObject implements Updatable {
    public function IdleAnim (color :PlayerColor) {
        _color = color;
    }

    public function get visible () :Boolean {
        return _visible;
    }

    public function set visible (value :Boolean) :void {
        if (_visible == value) return;

        _sprite.getChildAt(_idx).visible = _visible = value;
    }

    public function update (dt :Number) :void {
        if (!_visible) return;

        _elapsed += dt;
        while (_elapsed > SPF) {
            _elapsed -= SPF;
            incrementFrame();
        }
    }

    override protected function added () :void {
        var tex :Texture = TextureResource.requireImage("player").texture;
        var off :Point = _color.idleOffset;
        var size :int = GGJ.ACTOR_SHEET_TILE_PX;
        for (var ii :int = 0; ii < NUM_FRAMES; ii++) {
            var x :int = (off.x + ii) * size;
            var y :int = off.y * size;
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

    protected static const NUM_FRAMES :int = 10;
    protected static const SPF :Number = 0.2; // 5 FPS

    protected var _color :PlayerColor;
    protected var _idx :int = 0;
    protected var _elapsed :Number = 0;
    protected var _visible :Boolean;
}
