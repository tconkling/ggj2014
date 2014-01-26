package ggj.game.object {

import ggj.GGJ;
import ggj.desc.GameDesc;
import ggj.game.desc.PlayerColor;

public class ActiveBoardMgr extends BattleObject {
    public function get activeBoard () :BattleBoard {
        return _boards[_activeIdx];
    }

    public function updateActiveBoard () :void {
        var changed :Boolean;
        var actors :Array = Actor.getAll(this.mode);
        for each (var a :Actor in actors) {
            if (a.requestMapChange) {
                _activeIdx = a.team.ordinal();
                changed = true;
                break;
            }
        }
        if (changed) {
            _ctx.boardLayer.setChildIndex(_boards[_activeIdx].view.display, _boards.length - 1);
            for (var ii :int = 0; ii < _boards.length; ii++) {
                _boards[ii].view.display.alpha = ii == _activeIdx ? 1.0 : BACKGROUND_BOARD_ALPHA;
            }
        }
    }

    override protected function added () :void {
        _activeIdx = GGJ.RAND.getIntInRange(0, _ctx.numPlayers);
        var boardNames :Vector.<String> = BOARD_NAMES.concat();
        for (var ii :int = 0; ii < _ctx.numPlayers; ii++) {
            var boardName :String = GGJ.RAND.pluck(boardNames, BOARD_NAMES[0]);
            var board :BattleBoard = new BattleBoard(GameDesc.lib.getTome(boardName),
                PlayerColor.values()[ii]);
            addObject(board);
            if (ii != _activeIdx) {
                board.view.display.alpha = BACKGROUND_BOARD_ALPHA;
            }
            _boards.push(board);
        }
        _ctx.boardLayer.setChildIndex(_boards[_activeIdx].view.display, _boards.length - 1);
    }

    protected var _activeIdx :int;
    protected var _boards :Vector.<BattleBoard> = new <BattleBoard>[];

    protected static const BOARD_NAMES :Vector.<String> = new <String>[
        "rgby_layout_1", "rgby_layout_2", "rgby_layout_3"
    ];

    protected static const BACKGROUND_BOARD_ALPHA :Number = 0.2;
}
}
