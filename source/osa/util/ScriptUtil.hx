package osa.util;

class ScriptUtil
{
	public static var DEFAULT_IMPORTS(default, null):Map<String, Dynamic>;

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
		
		trace('Importing $className');
		DEFAULT_IMPORTS.set(className, cls);
	}
}
