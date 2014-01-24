//
// ggj-core

package ggj.microtome {

import flashbang.util.IntRange;

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.marshaller.ObjectMarshaller;

public class IntRangeMarshaller extends ObjectMarshaller
{
    public function IntRangeMarshaller () {
        super(false);
    }

    override public function get valueClass () :Class {
        return IntRange;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        const min :int = reader.requireInt("min");
        if (reader.hasValue("range")) {
            return new IntRange(min, reader.requireInt("range"));
        } else {
            const out :IntRange = new IntRange();
            out.min = min;
            out.max = reader.requireInt("max");
            return out;
        }
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        const out :IntRange = IntRange(obj);
        writer.writeInt("min", out.min);
        writer.writeInt("range", out.range);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return IntRange(data).clone();
    }
}
}

