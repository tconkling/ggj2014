#
# ggj2014

import logging

from ggj.game.desc.BoardDesc import BoardDesc
from ggj.game.desc.TileDesc import TileDesc
from ggj.game.desc.enums import TileType

from tools.csv_grid import Grid


LOG = logging.getLogger(__name__)

TILE_TYPES = {
    '#': TileType.BLOCK,
    '[': TileType.E,
    '-': TileType.EW,
    ']': TileType.W,
    'A': TileType.S,
    '|': TileType.NS,
    'U': TileType.N,
    '<': TileType.ES,
    '>': TileType.SW,
    'L': TileType.NE,
    'J': TileType.NW,
    'X': TileType.NESW,
    'T': TileType.ESW,
    '{': TileType.NSW,
    '}': TileType.NES,
    'V': TileType.NEW,
    '~': TileType.EW_BROKEN,
    'M': TileType.SPIKE_GROUND,
    'W': TileType.SPIKE_CEIL,
    'O': TileType.PERMANENT,
    '@': TileType.SPAWN,
    '$': TileType.GOAL
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

        # process the cells
        for (xx, yy, symbol) in grid.symbols:
            self._process_symbol(xx, yy, symbol)

    def _process_symbol(self, x, y, symbol):
        if symbol in TILE_TYPES:
            self._get_tile_desc(x, y).type = TILE_TYPES[symbol]
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
