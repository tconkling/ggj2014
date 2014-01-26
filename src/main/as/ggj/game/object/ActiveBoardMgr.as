package ggj.game.object {

import ggj.GGJ;
import ggj.desc.GameDesc;
import ggj.game.desc.PlayerColor;

public class ActiveBoardMgr extends BattleObject {
    public function get activeBoard () :BattleBoard {
        return _boards[_activeIdx];
    }

    public function updateActiveBoard () :void {
        if (!_activeBoardChanged) return;

        _activeBoardChanged = false;
        _ctx.boardLayer.setChildIndex(_boards[_activeIdx].view.display, _boards.length - 1);
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
        _activeBoardChanged = true;
        updateActiveBoard();
    }

    protected var _activeIdx :int;
    protected var _activeBoardChanged :Boolean;
    protected var _boards :Vector.<BattleBoard> = new <BattleBoard>[];

    protected static const BOARD_NAMES :Vector.<String> = new <String>[
        "rgby_layout_1", "test-board"
    ];

    protected static const BACKGROUND_BOARD_ALPHA :Number = 0.2;
}
}
