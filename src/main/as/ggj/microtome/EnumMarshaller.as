//
// ggj-core

package ggj.microtome {

import aspire.util.Enum;

import microtome.core.Annotation;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.marshaller.ObjectMarshaller;

public class EnumMarshaller extends ObjectMarshaller
{
    public function EnumMarshaller () {
        super(true);
    }

    override public function get valueClass () :Class {
        return Enum;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return Enum.valueOf(type.clazz, reader.requireString(name));
    }

    override public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :* {
        return Enum.valueOf(type.clazz, anno.stringValue(null));
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        writer.writeString(name, Enum(obj).name());
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        // Enums are singletons. No need to clone.
        return data;
    }
}
}
