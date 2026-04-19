package osa.modding.events;

class ScriptEvent
{
	public var type(default, null):ScriptEventType;

	public var canceled(default, null):Bool = false;
	public var cancelable(default, null):Bool = false;

	public function new(type:ScriptEventType, cancelable:Bool = true)
	{
		this.type = type;
		this.cancelable = cancelable;
	}

	public function cancel()
	{
		if (cancelable)
			canceled = true;
	}

	public function toString():String
	{
		return '$type | $canceled';
	}
}

class UpdateScriptEvent extends ScriptEvent
{
	public var elapsed:Float;

	override public function new(elapsed:Float)
	{
		super(UPDATE, false);

		this.elapsed = elapsed;
	}

	override public function toString():String
	{
		return '$type | $elapsed';
	}
}
