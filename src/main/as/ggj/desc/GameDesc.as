//
// ggj-core

package ggj.desc {

import flashbang.core.Flashbang;
import flashbang.resource.ResourceSet;

import ggj.GGJ;
import ggj.microtome.EnumMarshaller;
import ggj.microtome.IntRangeMarshaller;
import ggj.microtome.MicrotomeTypes;
import ggj.microtome.NumRangeMarshaller;
import ggj.microtome.PointIMarshaller;
import ggj.microtome.Vector2Marshaller;

import microtome.Library;
import microtome.Microtome;
import microtome.MicrotomeCtx;

import react.Future;

public class GameDesc
{
    public static const lib :Library = new Library();
    public static const ctx :MicrotomeCtx = createContext();

    public static function registerResourceLoader () :void {
        Flashbang.rsrcs.registerResourceLoader("microtome", MicrotomeLibraryLoader);
    }

    public static function load () :Future {
        if (_tomeResources != null) {
            _tomeResources.unload();
        }
        lib.removeAllTomes();

        _tomeResources = new ResourceSet();
        _tomeResources.add(GGJ.resourceParams.tome);
        _tomeResources.load();
        return _tomeResources;
    }

    protected static function createContext () :MicrotomeCtx {
        const ctx :MicrotomeCtx = Microtome.createCtx();
        ctx.registerDataMarshaller(new EnumMarshaller());
        ctx.registerDataMarshaller(new Vector2Marshaller());
        ctx.registerDataMarshaller(new NumRangeMarshaller());
        ctx.registerDataMarshaller(new IntRangeMarshaller());
        ctx.registerDataMarshaller(new PointIMarshaller());
        ctx.registerTomeClasses(MicrotomeTypes.tomeClasses);
        return ctx;
    }

    protected static var _tomeResources :ResourceSet;
}
}

import flashbang.loader.BatchLoader;
import flashbang.loader.DataLoader;
import flashbang.loader.XmlLoader;
import flashbang.resource.Resource;
import flashbang.resource.ResourceLoader;

import ggj.desc.GameDesc;

import microtome.xml.XmlUtil;

class MicrotomeLibraryLoader extends ResourceLoader
{
    /** The name of the resource (required) */
    public static const NAME :String = "name";

    /** Array of xml datas */
    public static const DATA :String = "data";

    public function MicrotomeLibraryLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        _name = requireLoadParam(NAME, String);
        var datas :Array = requireLoadParam(DATA, Array);

        _batch = new BatchLoader();
        for each (var data :Object in datas) {
            _batch.addLoader(new XmlLoader(data));
        }
        _batch.onSuccess(onXmlLoaded);
        _batch.onFailure(fail);
        _batch.load();
    }

    protected function onXmlLoaded (loaders :Vector.<DataLoader>) :void {
        try {
            const xmls :Vector.<XML> = new <XML>[];
            for each (var loader :XmlLoader in loaders) {
                xmls.push(loader.result);
            }
            GameDesc.ctx.load(GameDesc.lib, XmlUtil.createReaders(xmls));
            // dummy resource for now
            succeed(new Resource(_name));
        } catch (e :Error) {
            fail(e);
        }
    }

    override protected function onCanceled () :void {
        if (_batch != null) {
            _batch.close();
            _batch = null;
        }
    }

    protected var _name :String;
    protected var _batch :BatchLoader;
}
