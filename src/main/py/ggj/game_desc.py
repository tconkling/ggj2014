#
# ggj2014

import microtome.ctx
from ggj.tome import MicrotomeTypes
from ggj.tome.enum_marshaller import EnumMarshaller


def create_ctx():
    ctx = microtome.ctx.create_ctx()
    ctx.register_data_marshallers([
        EnumMarshaller()
    ])
    ctx.register_tome_classes(MicrotomeTypes.get_tome_classes())
    return ctx