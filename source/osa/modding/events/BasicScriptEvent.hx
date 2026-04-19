package osa.modding.events;

class BasicScriptEvent
{
	public var type(default, null):ScriptEventType;

	public var cancelled(default, null):Bool = false;

	public function new(type:ScriptEventType)
	{
		this.type = type;
	}

	public function cancel()
		cancelled = true;

	public function toString():String
	{
		return '$type | $cancelled';
	}
}
