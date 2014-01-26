//
// ggj

package ggj.game {

import flashbang.core.GameObject;

import ggj.game.desc.PlayerColor;
import ggj.game.object.ActiveBoardMgr;
import ggj.game.object.GameStateMgr;

import starling.display.Sprite;

public class BattleCtx extends GameObject
{
    public const boardLayer :Sprite = new Sprite();
    public const uiLayer :Sprite = new Sprite();
    public const debugLayer :Sprite = new Sprite();

    public var numPlayers :int;
    public var stateMgr :GameStateMgr;
    public var boardMgr :ActiveBoardMgr;

    public var params :Params;
    public var scoreboard :Scoreboard;

    public function BattleCtx (numPlayers :int, params :Params, scoreboard :Scoreboard) {
        this.numPlayers = numPlayers;
        this.params = params;
        this.scoreboard = scoreboard;
    }

    public var playerColors :Vector.<PlayerColor> = new <PlayerColor>[];
}
}
