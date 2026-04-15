package osa.util;

import flixel.FlxG;

class Constants
{
	public static final DEFAULT_BLUR_FOCUS:Float = 0;
	public static final DEFAULT_BLUR_UNFOCUS:Float = 4;

	public static final DEFAULT_LERP_SPEED:Float = 0.04;

	public static function getTimestamp():String
	{
		final dateNow:Date = Date.now();

		final seconds:Float = dateNow.getTime() / 1000;
		final date:String = '${dateNow.getMonth()}-${dateNow.getDate()}-${dateNow.getFullYear()}';

		return '${date}_${seconds}';
	}

	public static inline function selectSfx()
	{
		FlxG.sound.play('sounds/select${FlxG.random.int(1, 4)}'.menuAsset().audioFile());
	}

	public static inline function cancelSfx()
	{
		FlxG.sound.play('sounds/cancel'.menuAsset().audioFile());
	}
}
