package osa.modding.scripting;

import haxe.io.Path;
import crowplexus.iris.Iris;
import polymod.util.DefineUtil;

class ScriptHandler
{
	public static var registeredScripts:Map<String, Iris> = [];

	public static var SCRIPT_PATHS(get, never):Array<String>;

	static function get_SCRIPT_PATHS():Array<String>
	{
		var rootPath:String = DefineUtil.getDefineString('POLYMOD_ROOT_PATH');
		var paths:Array<String> = [rootPath.assetPath()];

		for (mod in ModCore.loadedMods)
			paths.push(ModCore.MOD_ROOT + '/' + mod.dirName + '/' + rootPath);

		return paths;
	}

	public static function loadScripts()
	{
		clearScripts();

		for (path in SCRIPT_PATHS)
			if (ModCore.modFileSystem.exists(path))
				for (file in ModCore.modFileSystem.readDirectoryRecursive(path))
				{
					if (Path.extension(file) != Path.extension(''.scriptFile()))
						return;

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
