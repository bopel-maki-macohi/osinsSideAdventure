package osa.util;

import osa.util.macros.GitMacro;

class Constants
{
	public static final DEFAULT_BLUR_FOCUS:Float = 0;
	public static final DEFAULT_BLUR_UNFOCUS:Float = 4;

	public static final DEFAULT_LERP_SPEED:Float = 0.04;

	public static final ITERATION_SPEAKERDATA:Int = 0;
	public static final ITERATION_TALEDATA:Int = 0;

	public static var GIT_STRING(get, null):String;

	static function get_GIT_STRING():String
	{
		return ((GitMacro.getHasLocalChanges()) ? 'local_' : '') + '${GitMacro.getGitBranch()}:${GitMacro.getGitCommit()}';
	}
}
