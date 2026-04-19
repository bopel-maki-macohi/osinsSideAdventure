package osa.modding.events;

class BasicScriptEvent
{
	public var type(default, null):ScriptEventType;

	public var cancelled(default, null):Bool = false;
	public var cancellable(default, null):Bool = false;

	public function new(type:ScriptEventType, cancellable:Bool = true)
	{
		this.type = type;
		this.cancellable = cancellable;
	}

	public function cancel()
	{
		if (cancellable)
			cancelled = true;
	}

	public function toString():String
	{
		return '$type | $cancelled';
	}
}
