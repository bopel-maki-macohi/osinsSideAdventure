package osa.modding.modules;

import osa.modding.events.ScriptEvent;

class Module implements IScriptedEventClass
{
	public var id:String = '';

	public function new(id:String)
	{
		this.id = id;
	}

	public function toString():String
		return '$id';

	public function onCreate(event:ScriptEvent):Void {}

	public function onUpdate(event:UpdateScriptEvent):Void {}

	public function onDestroy(event:ScriptEvent):Void {}

	public function onScriptEvent(event:ScriptEvent):Void {}
}
