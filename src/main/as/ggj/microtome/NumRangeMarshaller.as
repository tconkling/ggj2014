//
// ggj-core

package ggj.microtome {

import flashbang.util.NumRange;

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.marshaller.ObjectMarshaller;

public class NumRangeMarshaller extends ObjectMarshaller
{
    public function NumRangeMarshaller () {
        super(false);
    }

    override public function get valueClass () :Class {
        return NumRange;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        const min :Number = reader.requireNumber("min");
        if (reader.hasValue("range")) {
            return new NumRange(min, reader.requireNumber("range"));
        } else {
            const out :NumRange = new NumRange();
            out.min = min;
            out.max = reader.requireNumber("max");
            return out;
        }
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        const numRange :NumRange = NumRange(obj);
        writer.writeNumber("min", numRange.min);
        writer.writeNumber("range", numRange.range);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return NumRange(data).clone();
    }
}
}

