package osa.modding.events.basic;

class UpdateScriptEvent extends BasicScriptEvent
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
