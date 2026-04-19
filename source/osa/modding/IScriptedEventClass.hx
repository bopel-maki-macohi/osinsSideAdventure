package osa.modding;

import osa.modding.events.BasicScriptEvent;

interface IScriptedEventClass
{
	public function onCreate(event:BasicScriptEvent) {}

	public function onUpdate(event:BasicScriptEvent) {}

	public function onDestroy(event:BasicScriptEvent) {}
}
