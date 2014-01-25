#
# Global Game Jam 2014

# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class TileDesc(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(TileDesc, self).__init__(name)
        if not TileDesc._s_inited:
            TileDesc._s_inited = True
            TileDesc._s_xSpec = PropSpec("x", {"min": 0.0}, [int, ])
            TileDesc._s_ySpec = PropSpec("y", {"min": 0.0}, [int, ])
            TileDesc._s_typeSpec = PropSpec("type", {"default": "STONE"}, [TileType, ])

        self._x = Prop(self, TileDesc._s_xSpec)
        self._y = Prop(self, TileDesc._s_ySpec)
        self._type = Prop(self, TileDesc._s_typeSpec)
# GENERATED CONSTRUCTOR END

# GENERATED CLASS_BODY START
    @property
    def x(self):
        return self._x.value

    @x.setter
    def x(self, value):
        self._x.value = value

    @property
    def y(self):
        return self._y.value

    @y.setter
    def y(self, value):
        self._y.value = value

    @property
    def type(self):
        return self._type.value

    @type.setter
    def type(self, value):
        self._type.value = value

    @property
    def props(self):
        return super(TileDesc, self).props + [self._x, self._y, self._type, ]
# GENERATED CLASS_BODY END

# GENERATED POST-IMPORTS START
from ggj.game.desc import TileType
# GENERATED POST-IMPORTS END
