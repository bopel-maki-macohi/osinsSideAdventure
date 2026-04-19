package osa.modding.scripting;

import osa.util.ScriptUtil;
import osa.util.WindowUtil;
import crowplexus.iris.Iris;

class BasicScript extends Iris
{
	public static var registeredScripts:Map<String, BasicScript> = [];

	override public function new(script:String)
	{
		super(script.scriptFile().fileExists() ? '' : script.scriptFile().readText(), {
			name: script.scriptFile()
		});

		onLoad();
	}

	public function onLoad()
	{
		if (!config.name.fileExists())
		{
			WindowUtil.alert('Script Error : Missing Script', 'Missing Script File: ${config.name}');
			return;
		}

		if (registeredScripts.exists(config.name))
		{
			trace('The following Script File is already registered and will be overwritten: ${config.name}');
			registeredScripts.remove(config.name);
		}

		registeredScripts.set(config.name, this);

		for (clsName => cls in ScriptUtil.DEFAULT_IMPORTS)
			set(clsName, cls, false);

		call('onLoad');
	}
}
