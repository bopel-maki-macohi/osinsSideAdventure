package osa.modding;

import osa.modding.events.basic.*;

interface IScriptedEventClass
{
	public function onCreate(event:BasicScriptEvent):Void;

	public function onUpdate(event:UpdateScriptEvent):Void;

	public function onDestroy(event:BasicScriptEvent):Void;

	public function onScriptEvent(event:BasicScriptEvent):Void;
}
