package osa.modding.events;

class BasicScriptEvent
{
	public var id(default, null):String;

	public var cancelled(default, null):Bool = false;

	public function new(id:String)
	{
		this.id = id;
	}

	public function cancel()
		cancelled = true;

	public function toString():String
	{
		return '$id | $cancelled';
	}
}
