package ggj.game.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.ObjectTask;
import flashbang.resource.ImageResource;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.SerialTask;
import flashbang.util.Easing;

import ggj.GGJ;
import ggj.game.desc.PlayerColor;

import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

public class PowerView extends BattleSpriteObject {
    public function PowerView (color :PlayerColor) {
        _color = color;
    }

    public function get on () :Boolean {
        return _on;
    }

    public function set on (value :Boolean) :void {
        if (_on == value) return;
        _on = value;
        updateState();
    }

    override protected function added () :void {
        var tex :Texture = ImageResource.createImage("game/tilesheet").texture;
        var size :Number = GGJ.TILE_SHEET_TILE_PX;
        _offImg = new Image(Texture.fromTexture(tex,
            new Rectangle((OFF_OFFSET.x + _color.ordinal()) * size, OFF_OFFSET.y * size, size, size)));
        _onImg = new Image(Texture.fromTexture(tex,
            new Rectangle((ON_OFFSET.x + _color.ordinal()) * size, ON_OFFSET.y * size, size, size)));
        _burstImg = new Image(Texture.fromTexture(tex,
            new Rectangle((BURST_OFFSET.x + _color.ordinal()) * size, BURST_OFFSET.y * size, size, size)));

        _offImg.scaleX = _offImg.scaleY = _onImg.scaleX = _onImg.scaleY = _burstImg.scaleX =
            _burstImg.scaleY = GGJ.TILE_SIZE_PX / GGJ.TILE_SHEET_TILE_PX;
        _offImg.smoothing = _onImg.smoothing = _burstImg.smoothing = TextureSmoothing.NONE;
        _sprite.addChild(_offImg);
        _sprite.addChild(_onImg);
        _sprite.addChild(_burstImg);
        addObject(new RepeatingTask(function () :ObjectTask {
            return new SerialTask(
                new AlphaTask(1.0, 0.3, Easing.easeOut, _burstImg),
                new AlphaTask(0.0, 0.3, Easing.easeIn, _burstImg));
        }));
        updateState();
    }

    protected function updateState () :void {
        _offImg.visible = !_on;
        _onImg.visible = _on;
        _burstImg.visible = _on;
    }

    protected static const OFF_OFFSET :Point = new Point(9, 4);
    protected static const ON_OFFSET :Point = new Point(13, 4);
    protected static const BURST_OFFSET :Point = new Point(13, 5);

    protected var _color :PlayerColor;
    protected var _offImg :Image;
    protected var _onImg :Image;
    protected var _burstImg :Image;
    protected var _on :Boolean;
}
}
