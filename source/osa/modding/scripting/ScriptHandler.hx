package osa.modding.scripting;

import polymod.util.DefineUtil;

class ScriptHandler
{
	public static var registeredScripts:Map<String, BasicScript> = [];

	public var SCRIPT_PATH(get, never):String;

	function get_SCRIPT_PATH():String
	{
		return DefineUtil.getDefineString('POLYMOD_ROOT_PATH').assetPath();
	}

	public static function loadScripts()
	{
		clearScripts();

		for (file in ModCore.modFileSystem.readDirectoryRecursive(SCRIPT_PATH))
		{
			trace('Potential script: $file');
		};
	}

	public static function clearScripts()
	{
		for (path => script in registeredScripts)
		{
			registeredScripts.remove(path);
			script.destroy();
		}
	}
}
