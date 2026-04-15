package osa.util;

import lime.app.Application;
import osa.util.macros.OutdatedMacro;
import osa.util.macros.GitMacro;
import flixel.FlxG;

class Constants
{
	public static final LOREM_IPSUM:String = 'Lorem ipsum dolor sit amet';

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

	public static var GIT_STRING(get, null):String;

	static function get_GIT_STRING():String
	{
		return ((GitMacro.getHasLocalChanges()) ? 'local_' : '') + '${GitMacro.getGitBranch()}:${GitMacro.getGitCommit()}';
	}

	public static var OUTDATED(get, null):Bool;

	static function get_OUTDATED():Bool
	{
		return OutdatedMacro.getOutdated();
	}

	public static var VERSION(get, null):String;

	static function get_VERSION():String
	{
		return Application.current.meta.get('version');
	}
}
