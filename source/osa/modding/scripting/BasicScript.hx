package osa.modding.scripting;

import osa.util.ScriptUtil;
import osa.util.WindowUtil;
import crowplexus.iris.Iris;

class BasicScript extends Iris
{
	public static var registeredScripts:Map<String, BasicScript> = [];

	override public function new(script:String)
	{
		if (!script.scriptAsset().fileExists())
			WindowUtil.alert('Script Error : Missing Script', 'Missing Script File: ${script.scriptAsset()}');

		if (registeredScripts.exists(script.scriptAsset()))
		{
			trace('The following Script File is already registered and will be overwritten: ${script.scriptAsset()}');

			// WindowUtil.alert('Script Error : Already Registered Script',
			// 	'The following Script File is already registered and will be overwritten: ${script.scriptAsset()}');

			registeredScripts.remove(script.scriptAsset());
		}

		super(script.scriptAsset().fileExists() ? '' : path.readText(), {
			name: script.scriptAsset()
		});

		registeredScripts.set(script.scriptAsset(), this);

		onLoad();
	}

	public function onLoad()
	{
		for (clsName => cls in ScriptUtil.DEFAULT_IMPORTS)
			set(clsName, cls, false);

		call('onLoad');
	}
}
