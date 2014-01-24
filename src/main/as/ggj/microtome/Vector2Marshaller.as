//
// ggj-core

package ggj.microtome {

import aspire.geom.Vector2;

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.marshaller.ObjectMarshaller;

public class Vector2Marshaller extends ObjectMarshaller
{
    public function Vector2Marshaller () {
        super(false);
    }

    override public function get valueClass () :Class {
        return Vector2;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return new Vector2(reader.requireNumber("x"), reader.requireNumber("y"));
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        const vec :Vector2 = Vector2(obj);
        writer.writeNumber("x", vec.x);
        writer.writeNumber("y", vec.y);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return Vector2(data).clone();
    }
}
}
