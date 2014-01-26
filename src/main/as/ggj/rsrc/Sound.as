package ggj.rsrc {

import aspire.util.Enum;

import flashbang.audio.AudioChannel;
import flashbang.audio.SoundType;
import flashbang.core.Flashbang;
import flashbang.tasks.PlaySoundTask;

public class Sound extends Enum {
    public static const DEATH :Sound = new Sound("DEATH", GGJResources.SOUND_DEATH, 0.3);
    public static const LEVEL_SWAP :Sound = new Sound("LEVEL_SWAP", GGJResources.SOUND_LEVEL_SWAP,
        0.3);
    public static const MENU_SELECT_OPTION :Sound = new Sound("MENU_SELECT_OPTION",
        GGJResources.SOUND_MENU_SELECT_OPTION);
    public static const MENU_SELECT_PLAYER :Sound = new Sound("MENU_SELECT_PLAYER",
        GGJResources.SOUND_MENU_SELECT_PLAYER);
    public static const PLAYER_GOAL :Sound = new Sound("PLAYER_GOAL",
        GGJResources.SOUND_PLAYER_GOAL);
    public static const PLAYER_JUMP :Sound = new Sound("PLAYER_JUMP",
        GGJResources.SOUND_PLAYER_JUMP);
    public static const PLAYER_LAND :Sound = new Sound("PLAYER_LAND",
        GGJResources.SOUND_PLAYER_LAND);
    public static const PLAYER_SPAWN :Sound = new Sound("PLAYER_SPAWN",
        GGJResources.SOUND_PLAYER_SPAWN, 1.0);
    finishedEnumerating(Sound);

    public static function values () :Array {
        return Enum.values(Sound);
    }

    public static function valueOf (name :String) :Sound {
        return Enum.valueOf(Sound, name) as Sound;
    }

    public function get resourceDef () :Object {
        return {type: "sound", name: soundName, data: _cls, soundType: SoundType.SFX.name(),
            volume: _volume };
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

    public function Sound (name :String, cls :Class, volume :Number = 0.5) {
        super(name);
        _cls = cls;
        _volume = volume;
    }

    protected var _cls :Class;
    protected var _volume :Number;
}
}
