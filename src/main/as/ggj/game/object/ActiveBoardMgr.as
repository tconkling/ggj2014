package ggj.game.object {

import flashbang.core.Flashbang;
import flashbang.core.GameObjectBase;
import flashbang.resource.ImageResource;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.ParallelTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.Easing;

import ggj.GGJ;
import ggj.desc.GameDesc;
import ggj.game.desc.PlayerColor;
import ggj.rsrc.Sound;

import starling.display.Image;

public class ActiveBoardMgr extends BattleObject {
    public function get activeBoard () :BattleBoard {
        return _boards[_activeIdx];
    }

    public function updateActiveBoard (dt :Number) :void {
        if (!_ctx.stateMgr.playing) return;

        _elapsed += dt;
        var changed :Boolean;
        var actors :Array = Actor.getAll(this.mode);
        for each (var a :Actor in actors) {
            var idx :int = a.team.ordinal();
            var powerActive :Boolean = _powerOffCooldown[idx] < _elapsed;
            if (a.requestMapChange && powerActive && _activeIdx != idx) {
                _activeIdx = idx;
                _powerOffCooldown[idx] = _elapsed + POWER_COOLDOWN;
                changed = true;
                powerActive = false;
            }
            if (changed) break;
        }

        if (changed) {
            Sound.LEVEL_SWAP.play();
            updateBoardViews();
        }
    }

    public function isPowerActive (team :Team) :Boolean {
        return _powerOffCooldown[team.ordinal()] < _elapsed;
    }

    protected function updateBoardViews () :void {
        _ctx.boardLayer.setChildIndex(_boards[_activeIdx].view.display, _boards.length - 1);
        for (var ii :int = 0; ii < _boards.length; ii++) {
            _boards[ii].view.display.alpha = ii == _activeIdx ? 1.0 : BACKGROUND_BOARD_ALPHA;
        }
    }

    override protected function added () :void {
        _activeIdx = GGJ.RAND.getIntInRange(0, _ctx.numPlayers);
        var boardNames :Vector.<String> = BOARD_NAMES.concat();
        var availableColors :Array = PlayerColor.values();
        for (var ii :int = 0; ii < _ctx.numPlayers; ii++) {
            var boardName :String = GGJ.RAND.pluck(boardNames, BOARD_NAMES[0]);
            var playerColor :PlayerColor = availableColors[ii];
            _ctx.playerColors.push(playerColor);

            var board :BattleBoard = new BattleBoard(GameDesc.lib.getTome(boardName), playerColor);
            addObject(board);
            board.view.display.alpha = BACKGROUND_BOARD_ALPHA;
            _boards.push(board);

            _powerOffCooldown.push(-1);
        }

        updateBoardViews();

        // show an intro animation only for the first round
        if (!_ctx.scoreboard.hasScore && !GGJ.DEBUG) {
            addObject(new SerialTask(
                createIntroAnim(),
                new FunctionTask(_ctx.stateMgr.startAnimationComplete)));
        } else {
            _ctx.stateMgr.startAnimationComplete();
        }
    }

    protected function createIntroAnim () :GameObjectBase {
        // build up game start animation

        var ii :int = 0;
        var anim :SerialTask = new SerialTask();
        for (ii = 0; ii < _boards.length * 3; ii++) {
            var viewDelay :Number = BOARD_VIEW_DELAY;
            var fadeDelay :Number = BOARD_FADE_DELAY;
            if (ii == 0) {
                fadeDelay *= 2;
            } else if (ii >= _boards.length * 2) {
                // third time through supa fast
                viewDelay *= 0.25;
                fadeDelay *= 0.25;
            } else if (ii >= _boards.length) {
                // second time through fast
                viewDelay *= 0.5;
                fadeDelay *= 0.5;
            }

            var fade :ParallelTask = new ParallelTask();
            if (ii > 0) {
                fade.addTask(new AlphaTask(BACKGROUND_BOARD_ALPHA, fadeDelay, Easing.linear,
                    _boards[(ii - 1) % _boards.length].view.display));
            }
            fade.addTask(new AlphaTask(1.0, fadeDelay, Easing.linear,
                _boards[ii % _boards.length].view.display));
            fade.addTask(Sound.LEVEL_SWAP.task());

            // halfway though the fade, get the new top board on top.
            var swap :Function = function (boardIdx :int) :Function {
                return function () :void {
                    _ctx.boardLayer.setChildIndex(_boards[boardIdx].view.display, _boards.length - 1);
                }
            }(ii % _boards.length);
            fade.addTask(new SerialTask(new TimedTask(fadeDelay / 2), new FunctionTask(swap)));

            anim.addTask(fade);
            anim.addTask(new TimedTask(viewDelay));
        }

        // get our active board on top if it isn't already
        if (_activeIdx != _boards.length - 1) {
            anim.addTask(new ParallelTask(
                new AlphaTask(BACKGROUND_BOARD_ALPHA, BOARD_FADE_DELAY / 2, Easing.linear,
                    _boards[_boards.length - 1].view.display),
                new AlphaTask(1.0, BOARD_FADE_DELAY / 2, Easing.linear, activeBoard.view.display),
                new SerialTask(new TimedTask(BOARD_FADE_DELAY / 4), new FunctionTask(function () :void {
                    _ctx.boardLayer.setChildIndex(activeBoard.view.display, _boards.length - 1);
                }),
                Sound.LEVEL_SWAP.task())
            ));
        }

        var go :Image = ImageResource.createImage("game/level_start_go");
        go.x = (Flashbang.stageWidth - go.width) / 2;
        go.y = (Flashbang.stageHeight - go.height) / 2;
        go.visible = false;
        _ctx.uiLayer.addChild(go);
        anim.addTask(new FunctionTask(function () :void {
            go.visible = true;
        }));
        anim.addTask(new TimedTask(BOARD_VIEW_DELAY));
        anim.addTask(new FunctionTask(function () :void {
            _ctx.uiLayer.removeChild(go);
        }));

        return anim;
    }

    protected static const BOARD_NAMES :Vector.<String> = new <String>[
        "rgby_layout_1", "rgby_layout_2", "rgby_layout_3", "rgby_layout_4"
    ];

    protected static const BACKGROUND_BOARD_ALPHA :Number = 0.2;

    protected static const POWER_COOLDOWN :Number = 5.0;

    protected static const BOARD_VIEW_DELAY :Number = 0.4;
    protected static const BOARD_FADE_DELAY :Number = 0.2;

    protected var _activeIdx :int;
    protected var _boards :Vector.<BattleBoard> = new <BattleBoard>[];
    protected var _powerOffCooldown :Vector.<Number> = new <Number>[];
    protected var _elapsed :Number = 0;
}
}
