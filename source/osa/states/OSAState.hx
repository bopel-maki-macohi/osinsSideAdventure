package osa.states;

import osa.modding.scripting.ScriptHandler;
import osa.util.VersionUtil;
import osa.util.Constants;
import osa.util.Controls;
import osa.objects.RhythmManager;
import flixel.FlxCamera;
import flixel.addons.transition.Transition;
import flixel.math.FlxPoint;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIState;

class OSAState extends FlxUIState
{
	public static var DEFAULT_TRANSITION(get, never):TransitionData;

	static function get_DEFAULT_TRANSITION():TransitionData
	{
		var transGraphic = FlxGraphic.fromClass(cast GraphicTransTileDiamond);
		transGraphic.persist = true;
		transGraphic.destroyOnNoUse = false;

		return new TransitionData(TILES, FlxColor.WHITE, .5, FlxPoint.get(0, -1), {
			asset: transGraphic,
			width: 32,
			height: 32
		},);
	}

	override function create()
	{
		TRANSITION_CAMERA = new FlxCamera();
		FlxG.cameras.add(TRANSITION_CAMERA, false);
		TRANSITION_CAMERA.bgColor.alpha = 0;

		super.create();

		if (rhythmManager != null)
		{
			rhythmManager.beatHit.add(onBeatHit);
			rhythmManager.stepHit.add(onStepHit);
		}

		FlxG.inputs.addInput(controls);
	}

	public static var TRANSITION_CAMERA:FlxCamera;

	override function createTransition(data:TransitionData):Transition
	{
		final defaultTransition:Transition = super.createTransition(data);

		defaultTransition.camera = TRANSITION_CAMERA;

		return defaultTransition;
	}

	override function transitionOut(?OnExit:() -> Void)
	{
		onExit();
		super.transitionOut(OnExit);
	}

	function onExit() {}

	public var rhythmManager(get, never):RhythmManager;

	function get_rhythmManager():RhythmManager
	{
		return RhythmManager.instance;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		ScriptHandler.call('update', [elapsed]);

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

	public var controls(get, null):Controls;

	function get_controls():Controls
	{
		return Controls.instance;
	}
}
