//
// ggj

package ggj {

import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;

/**
 * <p>The following compiler argument is required to make this work:</p>
 * <pre>-frame=two,ggj.GGJWeb</pre>
 */
[SWF(width="960", height="640", frameRate="60", backgroundColor="#FFFFFF")]
public class GGJWebPreloader extends MovieClip
{
    public function GGJWebPreloader() {
        // the document class must be a MovieClip so that everything else can load on the 2nd frame
        stop();

        addChild(_splashScreen);

        _splashScreen.addChild(new IMAGE());

        // draw a progress bar
        const WIDTH :Number = 400;
        const HEIGHT :Number = 20;
        var progressBar :Shape = new Shape();
        progressBar.x = (this.stage.stageWidth - WIDTH) * 0.5;
        progressBar.y = this.stage.stageHeight - 43;
        _splashScreen.addChild(progressBar);
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

        _splashScreen.parent.removeChild(_splashScreen);
        removeChildren();

        var appClass :Class = getDefinitionByName("ggj.GGJWeb") as Class;
        addChild(new appClass(_splashScreen));
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

    protected var _splashScreen :Sprite = new Sprite();

    [Embed(source="../../../../rsrc/preloader.jpg")]
    protected static const IMAGE :Class;
}
}
