package osa.modding.scripting;

import osa.objects.RhythmManager;
import osa.util.WindowUtil;
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
		{
			// trace(path);

			if (ModCore.modFileSystem.exists(path))
				for (file in ModCore.modFileSystem.readDirectoryRecursive(path))
				{
					if (Path.extension(file) != Path.extension(''.scriptFile()))
						continue;

					trace('Potential script: $path$file');

					var script:Iris = new Iris('//${path + file}\n\n' + '$path$file'.readText(), {
						name: '$path$file'
					});

					registeredScripts.set(script.config.name, script);
				};
		}

		call('create');

		RhythmManager.instance.beatHit.add(onBeatHit);
		RhythmManager.instance.stepHit.add(onStepHit);
	}

	static function onBeatHit(curBeat:Int)
		call('onBeatHit', [curBeat]);

	static function onStepHit(curStep:Int)
		call('onStepHit', [curStep]);

	public static function clearScripts()
	{
		RhythmManager.instance?.beatHit?.remove(onBeatHit);
		RhythmManager.instance?.stepHit?.remove(onStepHit);

		for (path => script in registeredScripts)
		{
			registeredScripts.remove(path);
			script.destroy();
		}
	}

	public static function call(func:String, ?args:Array<Dynamic>)
		for (script in registeredScripts)
			if (script.exists(func))
				script.call(func, args);
}
