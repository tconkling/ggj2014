package ggj.game.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.core.Updatable;
import flashbang.objects.SpriteObject;

import ggj.GGJ;
import ggj.game.desc.TileType;

import starling.display.Image;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

public class SpawnTile extends SpriteObject implements Updatable {
    public function SpawnTile (tilesheet :Texture) {
        _tilesheet = tilesheet;
    }

    public function update (dt :Number) :void {
        _elapsed += dt;
        while (_elapsed > SPF) {
            _elapsed -= SPF;
            incrementFrame();
        }
    }

    override protected function added () :void {
        var size :int = GGJ.TILE_SHEET_TILE_PX;
        var off :Point = TileType.SPAWN.getTileCoordinates(null);
        for (var ii :int = 0; ii < NUM_FRAMES; ii++) {
            var x :int = off.x + ii * size;
            var y :int = off.y;
            var img :Image = new Image(Texture.fromTexture(_tilesheet,
                new Rectangle(x, y, size, size)));
            img.smoothing = TextureSmoothing.NONE;
            _sprite.addChild(img);
            img.visible = ii == 0;
        }
    }

    protected function incrementFrame () :void {
        _sprite.getChildAt(_idx).visible = false;
        _idx += _animDir;
        if (_idx > _sprite.numChildren - 1 || _idx < 0) {
            _idx = Math.max(Math.min(_idx, _sprite.numChildren - 1), 0);
            _animDir *= -1;
            _idx += _animDir;
        }
        _sprite.getChildAt(_idx).visible = true;
    }

    protected static const NUM_FRAMES :int = 3;
    protected static const SPF :Number = 0.1;

    protected var _tilesheet :Texture;
    protected var _animDir :int = 1;
    protected var _idx :int = 0;
    protected var _elapsed :Number = 0;
}
}
