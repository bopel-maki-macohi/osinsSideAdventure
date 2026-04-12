package osa;

import osa.objects.RhythmManager;
import flixel.FlxSubState;

class OSASubState extends FlxSubState
{
	public var _rhythmManager(get, never):RhythmManager;

	function get__rhythmManager():RhythmManager
	{
		return RhythmManager.instance;
	}

	override function create()
	{
		super.create();

		if (_rhythmManager != null)
		{
			_rhythmManager._beatHit.add(onBeatHit);
			_rhythmManager._stepHit.add(onStepHit);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_rhythmManager != null)
			_rhythmManager.update();
	}

	override public function destroy()
	{
		super.destroy();

		_rhythmManager._beatHit.remove(onBeatHit);
		_rhythmManager._stepHit.remove(onStepHit);
	}

	public function onBeatHit(curBeat:Int) {}

	public function onStepHit(curStep:Int) {}
}
