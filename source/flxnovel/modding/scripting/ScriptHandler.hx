package flxnovel.modding.scripting;

import flxnovel.util.ScriptUtil;
import flxnovel.objects.RhythmManager;
import flxnovel.util.WindowUtil;
import haxe.io.Path;
import crowplexus.iris.Iris;
import polymod.util.DefineUtil;

class ScriptHandler
{
	public static var registeredScripts:Map<String, Iris> = [];

	public static var SCRIPT_PATHS(get, never):Array<String>;

	static function get_SCRIPT_PATHS():Array<String>
	{
		return DefineUtil.getDefineString('POLYMOD_ROOT_PATH').getDirectories();
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

					if (registeredScripts.exists(Path.withoutExtension(file)))
					{
						var oldScript = registeredScripts.get(Path.withoutExtension(file));

						@:privateAccess
						trace('Overriding "${oldScript.scriptCode.split('\n')[0].substr(2)}" with "$path$file"');

						registeredScripts.remove(Path.withoutExtension(file));
						oldScript.destroy();
					}

					var script:Iris = new Iris('// ${path + file}\n\n' + '$path$file'.readText(), {
						name: Path.withoutExtension(file)
					});

					registeredScripts.set(script.config.name, script);
				};
		}

		for (key => value in ScriptUtil.DEFAULT_IMPORTS)
			set(key, value);

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

	public static function set(v:String, vv:Dynamic)
		for (script in registeredScripts)
			script.set(v, vv);
}
