#
# Global Game Jam 2014

# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class BoardDesc(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(BoardDesc, self).__init__(name)
        if not BoardDesc._s_inited:
            BoardDesc._s_inited = True
            BoardDesc._s_widthSpec = PropSpec("width", {"min": 1.0}, [int, ])
            BoardDesc._s_heightSpec = PropSpec("height", {"min": 1.0}, [int, ])
            BoardDesc._s_tilesSpec = PropSpec("tiles", None, [list, TileDesc, ])

        self._width = Prop(self, BoardDesc._s_widthSpec)
        self._height = Prop(self, BoardDesc._s_heightSpec)
        self._tiles = Prop(self, BoardDesc._s_tilesSpec)
# GENERATED CONSTRUCTOR END

# GENERATED CLASS_BODY START
    @property
    def width(self):
        return self._width.value

    @width.setter
    def width(self, value):
        self._width.value = value

    @property
    def height(self):
        return self._height.value

    @height.setter
    def height(self, value):
        self._height.value = value

    @property
    def tiles(self):
        return self._tiles.value

    @tiles.setter
    def tiles(self, value):
        self._tiles.value = value

    @property
    def props(self):
        return super(BoardDesc, self).props + [self._width, self._height, self._tiles, ]
# GENERATED CLASS_BODY END

# GENERATED POST-IMPORTS START
from ggj.game.desc.TileDesc import TileDesc
# GENERATED POST-IMPORTS END
