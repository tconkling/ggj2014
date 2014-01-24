//
// ggj-mobile

package ggj.util {

import aspire.util.LogTarget;

import pl.mllr.extensions.nativeUtils.NativeUtils;

public class NSLogTarget implements LogTarget
{
    public function log (msg :String) :void {
        _nativeUtils.nslog(msg);
    }

    protected const _nativeUtils :NativeUtils = new NativeUtils();
}
}
