package osa.modding;

import osa.modding.events.BasicScriptEvent;

interface IScriptedEventClass
{
	public function onCreate(event:BasicScriptEvent):Void;

	public function onUpdate(event:BasicScriptEvent):Void;

	public function onDestroy(event:BasicScriptEvent):Void;

	public function onScriptEvent(event:BasicScriptEvent):Void;
}
