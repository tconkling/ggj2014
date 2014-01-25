//
// ggj

package ggj.game {

import flashbang.core.GameObject;

import ggj.game.object.BattleBoard;

import starling.display.Sprite;

public class BattleCtx extends GameObject
{
    public const boardLayer :Sprite = new Sprite();
    public const uiLayer :Sprite = new Sprite();

    public var board :BattleBoard;
}
}
