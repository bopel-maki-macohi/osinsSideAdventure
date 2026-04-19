package osa.modding;

import osa.modding.events.ScriptEvent;

interface IScriptedEventClass
{
	public function onCreate(event:ScriptEvent) {}

	public function onUpdate(event:ScriptEvent) {}

	public function onDestroy(event:ScriptEvent) {}
}
