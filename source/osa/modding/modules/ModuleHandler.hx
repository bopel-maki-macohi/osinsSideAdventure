package osa.modding.modules;

import osa.modding.events.basic.*;
import osa.modding.events.*;

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

		dispatchEvent(new ScriptEvent(CREATE, false));
	}

	public static function clearModules()
	{
		var removed:Int = 0;

		dispatchEvent(new ScriptEvent(DESTROY, false));

		for (id => module in modules)
		{
			modules.remove(id);
		}

		trace('Cleared $removed Module(s)');
	}

	public static function dispatchEvent(event:ScriptEvent)
	{
		for (module in modules)
			ScriptEventDispatcher.dispatch(module, event);
	}
}
