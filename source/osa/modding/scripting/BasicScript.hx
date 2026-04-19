package osa.modding.scripting;

import osa.util.ScriptUtil;
import osa.util.WindowUtil;
import crowplexus.iris.Iris;

class BasicScript extends Iris
{
	public static var registeredScripts:Map<String, BasicScript> = [];

	override public function new(script:String)
	{
		if (!script.scriptFile().fileExists())
			WindowUtil.alert('Script Error : Missing Script', 'Missing Script File: ${script.scriptFile()}');

		if (registeredScripts.exists(script.scriptFile()))
		{
			trace('The following Script File is already registered and will be overwritten: ${script.scriptFile()}');

			// WindowUtil.alert('Script Error : Already Registered Script',
			// 	'The following Script File is already registered and will be overwritten: ${script.scriptFile()}');

			registeredScripts.remove(script.scriptFile());
		}

		super(script.scriptFile().fileExists() ? '' : script.scriptFile().readText(), {
			name: script.scriptFile()
		});

		registeredScripts.set(script.scriptFile(), this);

		onLoad();
	}

	public function onLoad()
	{
		for (clsName => cls in ScriptUtil.DEFAULT_IMPORTS)
			set(clsName, cls, false);

		call('onLoad');
	}
}
