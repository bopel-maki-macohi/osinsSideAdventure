package flxnovel.util;

import flixel.FlxG;
import flxnovel.util.macros.GitMacro;

class Constants
{
	public static final DEFAULT_BLUR_FOCUS:Float = 0;
	public static final DEFAULT_BLUR_UNFOCUS:Float = 4;

	public static final DEFAULT_LERP_SPEED:Float = 0.04;

	public static final ITERATION_SPEAKERDATA:Int = 2;
	public static final ITERATION_TALEDATA:Int = 2;
	public static final ITERATION_BACKGROUNDDATA:Int = 7;

	public static final MOD_ICON_SIZE_PIXELS:Int = 150;

	public static var GIT_STRING(get, never):String;

	static function get_GIT_STRING():String
	{
		return ((GitMacro.getHasLocalChanges()) ? 'local_' : '') + '${GitMacro.getGitBranch()}:${GitMacro.getGitCommit()}';
	}

	public static var GENERATED_BY(get, never):String;

	static function get_GENERATED_BY():String
	{
		return FlxG.stage.application.window.title;
	}
}
