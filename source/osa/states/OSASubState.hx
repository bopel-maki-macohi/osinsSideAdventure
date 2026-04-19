package osa.states;

import osa.modding.modules.ModuleHandler;
import osa.util.Controls;
import flixel.FlxG;
import osa.objects.RhythmManager;
import flixel.FlxSubState;

class OSASubState extends FlxSubState
{
	public var rhythmManager(get, never):RhythmManager;

	function get_rhythmManager():RhythmManager
	{
		return RhythmManager.instance;
	}

	override function create()
	{
		super.create();

		if (rhythmManager != null)
		{
			rhythmManager.beatHit.add(onBeatHit);
			rhythmManager.stepHit.add(onStepHit);
		}

		closeCallback = onClose;

		FlxG.inputs.addInput(controls);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (rhythmManager != null)
			rhythmManager.update();
	}

	override public function destroy()
	{
		super.destroy();

		rhythmManager.beatHit.remove(onBeatHit);
		rhythmManager.stepHit.remove(onStepHit);
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

	public function dispatchEvent(event:ScriptEvent)
	{
		ModuleHandler.callEvent(event);
	}
}
