//
// ${PROJECT_NAME}

package ggj.game.object {

import flashbang.core.Updatable;

public class GameStateMgr extends BattleObject implements Updatable {
    public function GameStateMgr () {
        _state = GameState.PLAYING;
    }

    public function get state () :GameState {
        return _state;
    }

    public function get winner () :Actor {
        return _winner;
    }

    public function get isGameOver () :Boolean {
        return (_state != GameState.PLAYING);
    }

    public function update (dt :Number) :void {
        if (!isGameOver) {
            var actors :Array = Actor.getAll(this.mode);
            if (actors.length == 0) {
                _state = GameState.EVERYONE_DIED;
            } else {
                for each (var a :Actor in actors) {
                    if (a.hitVictoryTile) {
                        _state = GameState.HAS_WINNER;
                        _winner = a;
                        break;
                    }
                }
            }
        }
    }

    protected var _state :GameState;
    protected var _winner :Actor;
}
}
