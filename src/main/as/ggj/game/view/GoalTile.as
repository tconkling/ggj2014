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

// TODO combine all this identical code with SpawnTile
public class GoalTile extends SpriteObject implements Updatable {
    public function GoalTile (tilesheet :Texture) {
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
        var off :Point = TileType.GOAL.getTileCoordinates(null);
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
        _idx = (_idx + 1) % _sprite.numChildren;
        _sprite.getChildAt(_idx).visible = true;
    }

    protected static const NUM_FRAMES :int = 2;
    protected static const SPF :Number = 2

    protected var _tilesheet :Texture;
    protected var _idx :int = 0;
    protected var _elapsed :Number = 0;
}
}
