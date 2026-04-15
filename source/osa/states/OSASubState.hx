package osa.states;

import osa.util.Controls;
import flixel.FlxG;
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

		closeCallback = onClose;

		FlxG.inputs.addInput(controls);
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

	function onClose()
	{
		if (this._parentState != null)
		{
			@:privateAccess
			if (this._parentState._requestedSubState == null)
				return;

			for (basic in members)
			{
				FlxG.state.add(basic);
			}
		}
	}

	public var controls(get, null):Controls;

	function get_controls():Controls
	{
		return Controls.instance;
	}
}
