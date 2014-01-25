#
# aciv

import logging
import re

from microtome.core.tome_ref import TomeRef
import microtome.util

from ggj.game.desc.enums import TileType

from aciv.game.desc.BoardDesc import BoardDesc
from aciv.game.desc.TileDesc import TileDesc
from aciv.game.desc.ActorSetupDesc import ActorSetupDesc
from aciv.game.desc.TreasureChestDesc import TreasureChestDesc
from aciv.game.desc.enums import TileFeature
from aciv.game.desc.enums import Team
from aciv.game.desc.enums import PlayerResourceType

from tools.csv_grid import Grid


LOG = logging.getLogger(__name__)

TILE_FEATURES = {
    '=': TileType.STONE
}


class BoardGenerator(object):
    def __init__(self, csv_filename, board_name, width=0, height=0):
        # read the csv
        with open(csv_filename) as csv:
            grid = Grid(csv.read(), width=width, height=height)

        # create the board
        self.board = BoardDesc(board_name)
        self.board.width = grid.width
        self.board.height = grid.height
        self.board.tiles = []
        self.board.actors = []
        self.board.chests = []

        # find all our quest locations
        self._quest_locs = {}  # <id: (x,y)>
        for (xx, yy, symbol) in grid.symbols:
            if not _is_id_symbol(symbol):
                continue
            symbol, the_id = _get_id_symbol(symbol)
            if symbol == QUEST_LOC:
                if the_id in self._quest_locs:
                    raise Exception("Duplicate quest location: '%s%d'" % (QUEST_LOC, the_id))
                self._quest_locs[the_id] = (xx, yy)

        # process the cells
        for (xx, yy, symbol) in grid.symbols:
            self._process_symbol(xx, yy, symbol)

        # we shouldn't have any unprocessed quest locs
        if len(self._quest_locs) > 0:
            the_id, value = self._quest_locs.popitem()
            raise Exception("Unused quest location: '%s%d" % (QUEST_LOC, the_id))

        # TODO: support for globals?
        self.board.numPointsToWin = NUM_POINTS_TO_WIN

    def _process_symbol(self, x, y, symbol):
        if symbol in TILE_FEATURES:
            self._get_tile_desc(x, y).feature = TILE_FEATURES[symbol]
        elif symbol in CREEPS:
            self.board.actors.append(_create_actor_setup_desc(x, y, Team.BADDIE, CREEPS[symbol]))
        elif symbol in NEUTRAL_ACTORS:
            self.board.actors.append(_create_actor_setup_desc(x, y, Team.NEUTRAL, NEUTRAL_ACTORS[symbol]))
        elif symbol in TREASURE_CHESTS:
            chest = TreasureChestDesc("chest")
            chest.x = x
            chest.y = y
            chest.quality = TREASURE_CHESTS[symbol]["quality"]
            self.board.chests.append(chest)
        elif symbol in TILE_OWNERSHIP:
            self._get_tile_desc(x, y).ownerTeam = TILE_OWNERSHIP[symbol]
        elif _is_id_symbol(symbol):
            self._process_id_symbol(x, y, symbol)
        else:
            raise Exception("Unrecognized symbol at (%d, %d): '%s'" % (x, y, symbol))

    def _process_id_symbol(self, x, y, symbol):
        symbol, the_id = _get_id_symbol(symbol)

        if symbol in PLAYER_ACTORS:
            if the_id == 0:
                team = Team.NEUTRAL
            elif the_id == 1:
                team = Team.PLAYER_1
            elif the_id == 2:
                team = Team.PLAYER_2
            else:
                raise Exception("Unrecognized team '%s'" % the_id)

            actor = _create_actor_setup_desc(x, y, team, PLAYER_ACTORS[symbol])
            self.board.actors.append(actor)

        elif symbol in QUEST_GIVERS:
            # get our associated quest location
            if not the_id in self._quest_locs:
                raise Exception("No matching quest loc for quest giver [id=%d]" % the_id)
            locX, locY = self._quest_locs.pop(the_id)
            actor = _create_actor_setup_desc(x, y, Team.NEUTRAL, QUEST_GIVERS[symbol]["desc_name"])
            actor.questGiverItemX = locX
            actor.questGiverItemY = locY
            actor.questGiverRewardType = QUEST_GIVERS[symbol]["type"]
            actor.questGiverRewardCount = QUEST_GIVERS[symbol]["count"]
            self.board.actors.append(actor)

        elif symbol == QUEST_LOC:
            pass # these get processed elsewhere

        else:
            raise Exception("Unrecognized symbol at (%d, %d): '%s'" % (x, y, symbol))

    def _get_tile_desc(self, xx, yy):
        for desc in self.board.tiles:
            if desc.x == xx and desc.y == yy:
                return desc
        desc = TileDesc("tile")
        desc.x = xx
        desc.y = yy
        self.board.tiles.append(desc)
        return desc

def _create_actor_setup_desc(x, y, team, tome_name):
    actor = ActorSetupDesc("actor")
    actor.x = x
    actor.y = y
    actor.team = team
    _set_tome_ref(actor, "actor", tome_name)
    return actor

def _set_tome_ref(desc, prop_name, tome_name):
    microtome.util.get_prop(desc, prop_name).value = TomeRef(tome_name)

def _is_id_symbol(symbol):
    return _get_id_symbol(symbol) is not None

def _get_id_symbol(symbol):
    '''input: "Q123" output: ("Q", 123)'''
    # find the first digit
    m = re.search('\d', symbol)
    if m is None:
        return None # fail

    digit_idx = m.start()
    digits = symbol[digit_idx:]
    if digit_idx == 0 or not digits.isdigit():
        return None # fail

    return (symbol[:digit_idx], int(digits))

if __name__ == "__main__":
    print _get_id_symbol("Q")
    print _get_id_symbol("123")
    print _get_id_symbol("Q123Q")
    print _get_id_symbol("Q123")
