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
    public var params :Params = new Params();

    public var playerColors :Vector.<PlayerColor> = new <PlayerColor>[];
}
}
