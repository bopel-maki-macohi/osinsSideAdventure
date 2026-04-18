package osa.util;

import flixel.FlxG;

class SoundUtil
{
	public static inline function selectSfx()
		FlxG.sound.play('sounds/select${FlxG.random.int(1, 4)}'.menuAsset().audioFile());

	public static inline function cancelSfx()
		FlxG.sound.play('sounds/cancel'.menuAsset().audioFile());
}
