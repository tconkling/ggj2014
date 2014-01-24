//
// ggj

package {

import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.system.Capabilities;
import flash.utils.getDefinitionByName;

/**
 * <p>The following compiler argument is required to make this work:</p>
 * <pre>-frame=two,ggj.GGJMobile</pre>
 */
[SWF(frameRate="60", backgroundColor="#000000")]
public class GGJMobilePreloader extends MovieClip
{
    public function GGJMobilePreloader() {
        const SCREEN_WIDTH :Number = Capabilities.screenResolutionY; // "Y" is always the longer dimension on tablets
        const SCREEN_HEIGHT :Number = Capabilities.screenResolutionX;

        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.align = StageAlign.TOP_LEFT;

        //the document class must be a MovieClip so that things can go on
        //the second frame.
        stop();

        addChild(_splash);

        _splash.addChild(new IMAGE());
        _splash.width = SCREEN_WIDTH;
        _splash.height = SCREEN_HEIGHT;

        // draw a progress bar
        const WIDTH :Number = 400;
        const HEIGHT :Number = 20;
        var progressBar :Shape = new Shape();
        progressBar.x = (SCREEN_WIDTH - WIDTH) * 0.5;
        progressBar.y = SCREEN_HEIGHT - 43;
        _splash.addChild(progressBar);
        loaderInfo.addEventListener(ProgressEvent.PROGRESS, function (e :ProgressEvent) :void {
            progressBar.graphics.clear();
            fillRect(progressBar, WIDTH, HEIGHT, 0xcccccc);
            fillRect(progressBar, WIDTH * (e.bytesLoaded / e.bytesTotal), HEIGHT, 0x455F46);
            outlineRect(progressBar, WIDTH, HEIGHT, 2, 0x000000);
        });

        loaderInfo.addEventListener(Event.COMPLETE, onComplete);
    }

    protected function onComplete (event:Event) :void {
        // go to frame two because that's where the classes we need are located
        gotoAndStop(2);

        _splash.parent.removeChild(_splash);
        removeChildren();

        var appClass :Class = getDefinitionByName("ggj.GGJMobile") as Class;
        addChild(new appClass(_splash));
    }

    protected static function fillRect (shape :Shape, w :Number, h :Number, color :uint) :void {
        var g :Graphics = shape.graphics;
        g.beginFill(color);
        g.drawRect(0, 0, w, h);
        g.endFill();
    }

    protected static function outlineRect (shape :Shape, w :Number, h :Number, lineSize :Number,
        color :uint) :void {

        var g :Graphics = shape.graphics;
        g.lineStyle(lineSize, color);
        g.drawRect(0, 0, w, h);
        g.endFill();
    }

    protected var _splash :Sprite = new Sprite();

    [Embed(source="../../../rsrc/Default-Landscape.png")]
    protected static const IMAGE :Class;
}
}
