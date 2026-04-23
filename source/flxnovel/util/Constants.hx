package flxnovel.util;

import flixel.FlxG;
import flxnovel.util.macros.GitMacro;

@:autoBuild(flxnovel.util.macros.ConstantsMacro.build('dev/post_0_12/constants.txt'))
class Constants
{
	public static var GIT_STRING(get, never):String;

	static function get_GIT_STRING():String
	{
		return '.${GitMacro.getGitCommit()}';
	}

	public static var GENERATED_BY(get, never):String;

	static function get_GENERATED_BY():String
	{
		return FlxG.stage.application.window.title;
	}
}
