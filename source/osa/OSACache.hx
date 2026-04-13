package osa;

import osa.states.visualnovel.DialogueSprite;
import osa.states.visualnovel.DialogueLine;
import osa.save.Save;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import osa.objects.TileScrollBG;
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

	public static function postStateSwitch()
	{
		for (key => sound in tempCachedSound)
		{
			if (sound == null)
				tempCachedSound.remove(key);

			sound.volume = 1 / 1000;
			sound.play(true);

			FlxTimer.wait((sound.length / 1000) / 1000, () ->
			{
				sound.stop();
			});
		}
	}

	public static function postUpdate()
	{
		for (key => texture in tempCachedTextures)
		{
			if (texture == null)
				tempCachedTextures.remove(key);

			forceRender(texture);
		}
	}

	public static function init()
	{
		/** Signals **/

		FlxG.signals.postStateSwitch.add(postStateSwitch);
		FlxG.signals.postUpdate.add(postUpdate);

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

		permCacheIssueTextures();
	}

	public static function permCacheIssueTextures()
	{
		var issueImgPaths:Map<String, Array<String>> = [];

		for (issue in Save.issues.get())
		{
			var issueArr = [];

			var char:DialogueSprite = new DialogueSprite(true);
			var bg:DialogueSprite = new DialogueSprite(false);

			// trace(issue);

			for (rawline in issue.parseDialogueFile())
			{
				var line:DialogueLine = new DialogueLine(rawline);

				if (line._isEvent)
					continue;

				// trace(line);

				if (line._character != null)
					char.build(line._character);
				if (line._bg != null)
					bg.build(line._bg);

				if (char?.graphic?.assetsKey != null)
					if (!issueArr.contains(char?.graphic?.assetsKey))
						issueArr.push(char?.graphic?.assetsKey);

				if (bg?.graphic?.assetsKey != null)
					if (!issueArr.contains(bg?.graphic?.assetsKey))
						issueArr.push(bg?.graphic?.assetsKey);
			}

			issueImgPaths.set(issue, issueArr);
		}

		var allImgPaths:Array<String> = [];
		var permCacheImgPaths:Array<String> = [];

		for (issue => imgs in issueImgPaths)
		{
			// trace('$issue : $imgs');

			for (img in imgs)
				allImgPaths.push(img);
		}

		for (img in allImgPaths)
		{
			final filteredallImgPaths = allImgPaths.filter(f -> return f == img);

			// trace('$img : ${filteredallImgPaths.length}');

			if (filteredallImgPaths.length > 1)
				permCacheImgPaths.push(img);
		}

		for (img in permCacheImgPaths)
			permCacheTexture(img);
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
