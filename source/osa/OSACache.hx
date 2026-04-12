package osa;

import openfl.Assets;
import openfl.media.Sound;

class OSACache
{

    static var permCachedSounds:Map<String, Sound> = [];

    public static function permCacheSound(key:String)
    {
        if (permCachedSounds.exists(key)) return;

        var sound:Null<Sound> = Assets.getSound(key);
        if (sound == null) return;

        trace('Perm cached: $key');
        permCachedSounds.set(key, sound);
    }
    
}