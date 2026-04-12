package osa;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.Assets;
import openfl.media.Sound;

class OSACache
{
	static var permCachedSounds:Map<String, Sound> = [];
	static var tempCachedSound:Map<String, Sound> = [];

	static var permCachedTextures:Map<String, FlxGraphic> = [];
	static var tempCachedTextures:Map<String, FlxGraphic> = [];

	public static function performCaches()
	{
		/** Audio Caching **/

		permCacheSound('updog/get-your-ass-up'.audioFile().miscAsset());

		permCacheSound('type1'.audioFile().visualNovelAsset());
		permCacheSound('type2'.audioFile().visualNovelAsset());
		permCacheSound('type3'.audioFile().visualNovelAsset());

		/** Texture Caching **/

		permCacheTexture('title/play'.imageFile().menuAsset());
		permCacheTexture('title/credits'.imageFile().menuAsset());
		permCacheTexture('title/options'.imageFile().menuAsset());

		permCacheTexture('logo'.imageFile().menuAsset());

		permCacheTexture('tile'.imageFile().menuAsset());
		permCacheTexture('tile-osin'.imageFile().menuAsset());
		permCacheTexture('tile-sinco'.imageFile().menuAsset());
		permCacheTexture('tile-tirok'.imageFile().menuAsset());
		permCacheTexture('tile-loroc'.imageFile().menuAsset());
	}

	public static function permCacheSound(key:String)
	{
		if (permCachedSounds.exists(key))
			return;

		var sound:Null<Sound> = Assets.getSound(key);
		if (sound == null)
			return;

		trace('Perm cached sound: $key');
		permCachedSounds.set(key, sound);
	}

	public static function tempCacheSound(key:String)
	{
		if (tempCachedSound.exists(key))
			return;

		var sound:Null<Sound> = Assets.getSound(key);
		if (sound == null)
			return;

		trace('Temp cached sound: $key');
		tempCachedSound.set(key, sound);
	}

	public static function permCacheTexture(key:String)
	{
		if (permCachedTextures.exists(key))
			return;

		var texture:Null<FlxGraphic> = FlxG.bitmap.add(key);
		if (texture == null)
			return;

		texture.persist = true;
		trace('Perm cached texture: $key');
		permCachedTextures.set(key, texture);
	}

	public static function tempCacheTexture(key:String)
	{
		if (tempCachedTextures.exists(key))
			return;

		var texture:Null<FlxGraphic> = FlxG.bitmap.add(key);
		if (texture == null)
			return;

		texture.destroyOnNoUse = true;
		trace('Temp cached texture: $key');
		tempCachedTextures.set(key, texture);
	}

	public static function clearTempTextureCache()
	{
		for (key => texture in tempCachedTextures)
		{
			tempCachedTextures.remove(key);
			texture.destroy();
		}
	}

	public static function clearTempSoundCache()
	{
		for (key => sound in tempCachedSound)
		{
			tempCachedTextures.remove(key);
			sound.close();
		}
	}
}
