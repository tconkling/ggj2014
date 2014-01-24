//
// ggj-mobile

package ggj {

import flash.filesystem.File;

import ggj.rsrc.GGJResources;

public class MobileResources extends GGJResources
{
    public function MobileResources () {
        _root = File.applicationDirectory;
    }

    override protected function url (path :String) :String {
        return _root.resolvePath(path).url;
    }

    protected var _root :File;
}
}
