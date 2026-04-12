package osa.states;

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

	public var _watermark:FlxText;

	override function create()
	{
		TRANSITION_CAMERA = new FlxCamera();
		FlxG.cameras.add(TRANSITION_CAMERA, false);
		TRANSITION_CAMERA.bgColor.alpha = 0;

		super.create();

		_watermark = new FlxText(10, 10, FlxG.width, 'O.S.A. ${FlxG.stage.application.meta.get('version')}', 16);
		_watermark.alignment = LEFT;
		_watermark.color = FlxColor.WHITE;
		_watermark.y = FlxG.height - _watermark.height;

		#if debug
		add(_watermark);
		#end

		#if DISABLE_TITLE_WATERMARK_BLUR
		var regCam = new FlxCamera();
		FlxG.cameras.add(regCam, false);
		regCam.bgColor.alpha = 0;

		_watermark.camera = regCam;
		#end

		if (_rhythmManager != null)
		{
			_rhythmManager._beatHit.add(onBeatHit);
			_rhythmManager._stepHit.add(onStepHit);
		}
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

	public var _rhythmManager(get, never):RhythmManager;

	function get__rhythmManager():RhythmManager
	{
		return RhythmManager.instance;
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
