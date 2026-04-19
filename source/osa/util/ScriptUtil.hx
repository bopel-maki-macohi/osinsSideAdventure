package osa.util;

class ScriptUtil
{
	public static var DEFAULT_IMPORTS(default, null):Map<String, Dynamic>;

	public static var BLACKLISTED_IMPORTS:Array<String> = [
		'lime.system.CFFI',
		'lime.system.JNI',
		'lime.system.System',
		'lime.utils.Assets',
		'openfl.utils.Assets',
		'openfl.Lib',
		'openfl.system.ApplicationDomain',
		'openfl.net.SharedObject',
		'openfl.desktop.NativeProcess',
		'Sys',
		'cpp.Lib',
		'haxe.Unserializer',
		'lime.utils.AssetLibrary',
	];

	public static function init()
	{
		buildDEFAULT_IMPORTS();
	}

	public static function buildDEFAULT_IMPORTS()
	{
		DEFAULT_IMPORTS = [];

		addImport(flixel.FlxG);
	}

	public static function addImport(cls:Dynamic)
	{
		var className = Type.getClassName(cls);

		if (BLACKLISTED_IMPORTS.contains(className))
		{
			trace('$className is blacklisted');
			return;
		}

		trace('Importing $className');
		DEFAULT_IMPORTS.set(className, cls);
	}
}
