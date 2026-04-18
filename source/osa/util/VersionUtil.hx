package osa.util;

import lime.app.Application;

class VersionUtil
{
	public static var OUTDATED_LATEST_VERSION(get, null):String;

	static function get_OUTDATED_LATEST_VERSION():String
	{
		return OutdatedUtil.getLatestVersion();
	}

	public static var OUTDATED(get, null):Bool;

	static function get_OUTDATED():Bool
	{
		return OUTDATED_LATEST_VERSION != VERSION;
	}

	public static var VERSION(get, null):String;

	static function get_VERSION():String
	{
		return Application.current.meta.get('version');
	}
}
