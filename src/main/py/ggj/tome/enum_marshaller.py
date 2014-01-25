#
# ggj2014

from flufl.enum import Enum
from flufl.enum._enum import EnumValue

from microtome.error import ValidationError
from microtome.marshaller.data_marshaller import ObjectMarshaller


class EnumMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, True)

    @property
    def value_class(self):
        return Enum

    @property
    def handles_subclasses(self):
        return True

    def read_value(self, mgr, reader, name, type_info):
        return type_info.clazz[reader.require_string(name)]

    def read_default(self, mgr, type_info, anno):
        return type_info.clazz[anno.string_value(None)]

    def write_value(self, mgr, writer, value, name, type_info):
        writer.write_string(name, value.name)

    def clone_object(self, mgr, obj, type_info):
        # enums are singletons. we don't clone.
        return obj

    def validate_prop(self, prop):
        if not prop.nullable and prop.value is None:
            raise ValidationError(prop, "null value for non-nullable prop")
        # we actually create EnumValues instances, not Enums
        elif prop.value and not isinstance(prop.value, EnumValue):
            raise ValidationError(prop, "incompatible value type [required=%s, actual=%s]" %
                                        (self.value_class.__name__, prop.value.__class__.__name__))
