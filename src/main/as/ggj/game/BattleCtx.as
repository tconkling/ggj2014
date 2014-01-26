//
// ggj

package ggj.game {

import flashbang.core.GameObject;

import ggj.game.object.BattleBoard;
import ggj.game.object.GameStateMgr;

import starling.display.Sprite;

public class BattleCtx extends GameObject
{
    public const boardLayer :Sprite = new Sprite();
    public const uiLayer :Sprite = new Sprite();
    public const debugLayer :Sprite = new Sprite();

    public var activeBoard :BattleBoard;
    public var boards :Vector.<BattleBoard> = new <BattleBoard>[];
    public var stateMgr :GameStateMgr;
    public var params :Params = new Params();
}
}
