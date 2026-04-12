package osa;

import flixel.sound.FlxSound;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.Assets;
import openfl.media.Sound;

class OSACache
{
	static var permCachedSounds:Map<String, FlxSound> = [];
	static var tempCachedSound:Map<String, FlxSound> = [];

	static var permCachedTextures:Map<String, FlxGraphic> = [];
	static var tempCachedTextures:Map<String, FlxGraphic> = [];

	public static function init()
	{
		/** Signals **/

		FlxG.signals.postStateSwitch.add(function()
		{
			for (key => sound in tempCachedSound)
			{
				sound.volume = 1 / 100;
				sound.play(true);
				sound.stop();
			}
			for (key => texture in tempCachedTextures)
			{
				texture.refresh();

				forceRender(texture);
			}
		});

		FlxG.signals.postUpdate.add(function()
		{
			for (key => texture in tempCachedTextures)
				forceRender(texture);
		});

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

		var sound:Null<FlxSound> = FlxG.sound.load(key);
		if (sound == null)
			return;

		trace('Perm cached sound: $key');

		sound.persist = true;

		FlxG.sound.cache(key);
		permCachedSounds.set(key, sound);
		tempCachedSound.set(key, sound);
	}

	public static function tempCacheSound(key:String)
	{
		if (tempCachedSound.exists(key))
			return;

		var sound:Null<FlxSound> = FlxG.sound.load(key);
		if (sound == null)
			return;

		trace('Temp cached sound: $key');

		FlxG.sound.cache(key);
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

		forceRender(texture);

		@:privateAccess
		FlxG.bitmap._cache.set(key, texture);

		permCachedTextures.set(key, texture);
		tempCachedTextures.set(key, texture);
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

		forceRender(texture);

		@:privateAccess
		FlxG.bitmap._cache.set(key, texture);

		tempCachedTextures.set(key, texture);
	}

	public static function forceRender(graphic:FlxGraphic)
	{
		var sprite:FlxSprite = new FlxSprite();
		sprite.loadGraphic(graphic);

		sprite.draw();
		graphic.bitmap?.getTexture(FlxG.stage.context3D);

		sprite.destroy();
	}

	public static function clearTempTextureCache()
	{
		for (key => texture in tempCachedTextures)
		{
			if (permCachedTextures.exists(key))
				continue;

			trace('Cleared temp cached texture: $key');

			@:privateAccess
			FlxG.bitmap._cache.remove(key);

			tempCachedTextures.remove(key);
			FlxG.bitmap.remove(texture);
		}
	}

	public static function clearTempSoundCache()
	{
		for (key => sound in tempCachedSound)
		{
			if (permCachedSounds.exists(key))
				continue;

			trace('Cleared temp cached sound: $key');

			tempCachedTextures.remove(key);
			sound.destroy();
		}
	}

	public static function clearTempCaches()
	{
		clearTempTextureCache();
		clearTempSoundCache();
	}
}
