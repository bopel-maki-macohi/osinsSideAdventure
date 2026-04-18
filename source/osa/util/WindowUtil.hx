package osa.util;

import flixel.FlxG;

class WindowUtil
{
	public static function alert(title:String, message:String)
		FlxG.stage.application.window.alert(message, title);
}
