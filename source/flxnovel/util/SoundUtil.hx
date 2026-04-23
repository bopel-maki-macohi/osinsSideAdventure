package flxnovel.util;

import lime.utils.Assets;
import flixel.sound.FlxSound;
import flixel.FlxG;

class SoundUtil
{
	public static inline function selectSfx()
		FlxG.sound.play('sounds/select${FlxG.random.int(1, 4)}'.audioFile().menuAsset());

	public static inline function cancelSfx()
		FlxG.sound.play('sounds/cancel'.audioFile().menuAsset());

	public static function getLoadedSoundsFromDirectory(directory:String)
	{
		var sounds:Array<FlxSound> = [];

		for (file in directory.getFilesInDirectory())
		{
			if (!file.endsWith(''.audioFile()))
				continue;

			sounds.push(FlxG.sound.load(file));
		}

		return sounds;
	}
}
