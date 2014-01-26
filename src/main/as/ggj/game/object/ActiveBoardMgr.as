package ggj.game.object {

import ggj.GGJ;
import ggj.desc.GameDesc;
import ggj.game.desc.PlayerColor;
import ggj.game.view.PowerView;

public class ActiveBoardMgr extends BattleObject {
    public function get activeBoard () :BattleBoard {
        return _boards[_activeIdx];
    }

    public function updateActiveBoard (dt :Number) :void {
        _elapsed += dt;
        var changed :Boolean;
        var actors :Array = Actor.getAll(this.mode);
        for each (var a :Actor in actors) {
            var idx :int = a.team.ordinal();
            var powerActive :Boolean = _powerOffCooldown[idx] < _elapsed;
            if (a.requestMapChange && powerActive) {
                _activeIdx = idx;
                _powerOffCooldown[idx] = _elapsed + POWER_COOLDOWN;
                changed = true;
                powerActive = false;
            }
            _powerViews[idx].on = powerActive;
            if (changed) break;
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
        var playerColors :Array = PlayerColor.values();
        for (var ii :int = 0; ii < _ctx.numPlayers; ii++) {
            var boardName :String = GGJ.RAND.pluck(boardNames, BOARD_NAMES[0]);
            var playerColor :PlayerColor = playerColors[ii];
            var board :BattleBoard = new BattleBoard(GameDesc.lib.getTome(boardName), playerColor);
            addObject(board);
            if (ii != _activeIdx) {
                board.view.display.alpha = BACKGROUND_BOARD_ALPHA;
            }
            _boards.push(board);

            var powerView :PowerView = new PowerView(playerColor);
            powerView.display.x =
                ((board.width - _ctx.numPlayers) / 2 + playerColor.ordinal()) * GGJ.TILE_SIZE_PX;
            powerView.display.y = (board.height) * GGJ.TILE_SIZE_PX;
            addObject(powerView, _ctx.uiLayer);
            powerView.on = true;
            _powerViews.push(powerView);
            _powerOffCooldown.push(-1);
        }
        _ctx.boardLayer.setChildIndex(_boards[_activeIdx].view.display, _boards.length - 1);
    }

    protected static const BOARD_NAMES :Vector.<String> = new <String>[
        "rgby_layout_1", "rgby_layout_2", "rgby_layout_3"
    ];

    protected static const BACKGROUND_BOARD_ALPHA :Number = 0.2;

    protected static const POWER_COOLDOWN :Number = 5.0;

    protected var _activeIdx :int;
    protected var _boards :Vector.<BattleBoard> = new <BattleBoard>[];
    protected var _powerViews :Vector.<PowerView> = new <PowerView>[];
    protected var _powerOffCooldown :Vector.<Number> = new <Number>[];
    protected var _elapsed :Number = 0;
}
}
