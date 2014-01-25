package ggj.game.object {

public class Collision {
    public var location :Number = 0;
    public var tile :Tile;

    public function set (location :Number, tile :Tile) :Collision {
        this.location = location;
        this.tile = tile;
        return this;
    }
}
}
