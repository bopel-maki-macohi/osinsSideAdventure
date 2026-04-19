package osa.util;

import osa.util.macros.ClassMacro;

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

		var classes:Array<Dynamic> = [];

		for (cls in ClassMacro.listClassesInPackage('flixel')) classes.push(cls);
		for (cls in ClassMacro.listClassesInPackage('flixel-addons')) classes.push(cls);
		for (cls in ClassMacro.listClassesInPackage('flixel-ui')) classes.push(cls);
		for (cls in ClassMacro.listClassesInPackage('flixel-controls')) classes.push(cls);

		for (cls in ClassMacro.listClassesInPackage('lime')) classes.push(cls);

		for (cls in ClassMacro.listClassesInPackage('openfl')) classes.push(cls);

		for (cls in classes)
		{
			if (cls == null)
				continue;

			var className:String = Type.getClassName(cls);

			addImport(className, cls);
		}
	}

	public static function addImport(className:String, cls:Dynamic)
	{
		if (BLACKLISTED_IMPORTS.contains(className))
		{
			trace('$className is blacklisted');
			return;
		}

		trace('Importing $className');
		DEFAULT_IMPORTS.set(className, cls);
	}
}
