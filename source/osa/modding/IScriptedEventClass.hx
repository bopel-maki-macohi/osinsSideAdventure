package osa.modding;

import osa.modding.events.ScriptEvent;

interface IScriptedEventClass
{
	public function onCreate(event:ScriptEvent):Void;

	public function onUpdate(event:ScriptEvent):Void;

	public function onDestroy(event:ScriptEvent):Void;
}
