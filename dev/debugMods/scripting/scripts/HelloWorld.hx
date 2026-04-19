package dev.debugMods.scripting.scripts;

import osa.modding.modules.Module;

class HelloWorld extends Module
{
	override public function new()
	{
		super('helloworld');

		trace('Hello World');
	}
}
