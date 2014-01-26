package ggj.game.object {

import flashbang.core.Flashbang;
import flashbang.core.Updatable;
import flashbang.layout.HLayoutSprite;
import flashbang.layout.VLayoutSprite;

import ggj.game.view.PowerView;
import ggj.util.Text;

import starling.utils.HAlign;

public class Hud extends BattleObject implements Updatable {
    public function Hud (boardMgr :ActiveBoardMgr) {
    }

    override protected function added () :void {
        var viewLayout :VLayoutSprite = new VLayoutSprite(2, HAlign.LEFT);

        for (var ii :int = 0; ii < _ctx.numPlayers; ii++) {
            var team :Team = Team.values()[ii];
            var playerInfoLayout :HLayoutSprite = new HLayoutSprite();

            // powerview
            var powerView :PowerView = new PowerView(_ctx.playerColors[ii]);
            addObject(powerView, playerInfoLayout);
            powerView.on = true;
            _powerViews.push(powerView);

            // score
            playerInfoLayout.addChild(Text.futura25("Score: " + _ctx.scoreboard.getScore(team))
                .color(team.color.color)
                .build());

            playerInfoLayout.layout();
            viewLayout.addChild(playerInfoLayout);
        }

        viewLayout.layout();
        _ctx.uiLayer.addChild(viewLayout);
        viewLayout.x = Flashbang.stageWidth - viewLayout.width - 5;
        viewLayout.y = (Flashbang.stageHeight - viewLayout.height) * 0.5;
    }

    public function update (dt :Number) :void {
        for each (var a :Actor in Actor.getAll(this.mode)) {
            _powerViews[a.team.ordinal()].on =
                _ctx.boardMgr.isPowerActive(a.team);
        }
    }

    protected var _powerViews :Vector.<PowerView> = new <PowerView>[];
}
}
