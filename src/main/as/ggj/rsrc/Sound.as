package ggj.rsrc {

import aspire.util.Enum;

import flashbang.audio.AudioChannel;
import flashbang.audio.SoundType;
import flashbang.core.Flashbang;
import flashbang.tasks.PlaySoundTask;

public class Sound extends Enum {
    public static const DEATH :Sound = new Sound("DEATH", GGJResources.SOUND_DEATH);
    finishedEnumerating(Sound);

    public static function values () :Array {
        return Enum.values(Sound);
    }

    public static function valueOf (name :String) :Sound {
        return Enum.valueOf(Sound, name) as Sound;
    }

    public function get resourceDef () :Object {
        return {type: "sound", name: soundName, data: _cls, soundType: SoundType.SFX.name() };
    }

    public function get soundName () :String {
        return "sounds/" + name();
    }

    public function play () :AudioChannel {
        return Flashbang.audio.playSoundNamed(soundName);
    }

    public function loop () :AudioChannel {
        return Flashbang.audio.playSoundNamed(soundName, null, -1);
    }

    public function task (waitForComplete :Boolean = false) :PlaySoundTask {
        return new PlaySoundTask(soundName, waitForComplete);
    }

    public function Sound (name :String, cls :Class) {
        super(name);
        _cls = cls;
    }

    protected var _cls :Class;
}
}
