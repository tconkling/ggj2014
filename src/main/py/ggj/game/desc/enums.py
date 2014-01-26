from flufl.enum import Enum

# unless otherwise noted, these enums' values don't matter
# API: TileType.STONE.name == "STONE"; TileType.STONE.value == 0


class TileType(Enum):
    BLOCK = 0
    E = 1
    EW = 2
    W = 3
    S = 4
    NS = 5
    N = 6
    ES = 7
    SW = 8
    NE = 9
    NW = 10
    NESW = 11
    ESW = 12
    NSW = 13
    NES = 14
    NEW = 15
    EW_BROKEN = 16
    SPIKE_GROUND = 17
    SPIKE_CEIL = 18
    PERMANENT = 19
    SPAWN = 20
    GOAL = 21
