//
// ggj-core

package ggj.microtome {

import aspire.geom.PointI;

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.marshaller.ObjectMarshaller;

public class PointIMarshaller extends ObjectMarshaller
{
    public function PointIMarshaller () {
        super(true);
    }

    override public function get valueClass () :Class {
        return PointI;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        var ints :Array = reader.requireInts(name, 2);
        return new PointI(ints[0], ints[1]);
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        const p :PointI = PointI(obj);
        writer.writeString(name, "" + p.x + "," + p.y);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return PointI(data).clone();
    }
}
}

