package ggj.game.object {

import aspire.util.Enum;

public final class GameState extends Enum
{
    public static const PLAYING :GameState = new GameState("PLAYING");
    public static const EVERYONE_DIED :GameState = new GameState("EVERYONE_DIED");
    public static const HAS_WINNER :GameState = new GameState("HAS_WINNER");
    finishedEnumerating(GameState);

    public static function values () :Array {
        return Enum.values(GameState);
    }

    public static function valueOf (name :String) :GameState {
        return Enum.valueOf(GameState, name) as GameState;
    }

    public function GameState (name :String) {
        super(name);
    }
}
}

