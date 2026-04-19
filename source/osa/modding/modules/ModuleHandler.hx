package osa.modding.modules;

class ModuleHandler
{
	public static var modules:Map<String, Module> = [];

	public static function loadModules()
	{
		clearModules();

		for (cls in ScriptedModule.listScriptClasses())
		{
			var module:Module = ScriptedModule.scriptInit(cls, cls);

			if (module != null)
			{
				trace('Loaded module: $cls');
				modules.set(cls, module);
			}
			else
			{
				trace('Failed to load module: $cls');
			}
		}
	}

	public static function clearModules()
	{
		var removed:Int = 0;

		for (id => module in modules)
		{
			modules.remove(id);
		}

		trace('Cleared $removed Module(s)');
	}
}
