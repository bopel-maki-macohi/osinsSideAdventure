package osa.modding.events.bases;

class ScriptEvent
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
