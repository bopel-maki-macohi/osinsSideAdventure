package osa.modding.modules;

import osa.modding.events.BasicScriptEvent;

class Module implements IScriptedEventClass
{
	public var id:String = '';

	public function new(id:String)
	{
		this.id = id;
	}

	public function toString():String
		return '$id';

	public function onCreate(event:BasicScriptEvent):Void {}

	public function onUpdate(event:BasicScriptEvent):Void {}

	public function onDestroy(event:BasicScriptEvent):Void {}

	public function onScriptEvent(event:BasicScriptEvent):Void {}
}
