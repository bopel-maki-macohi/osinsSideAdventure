package osa.objects;

import flixel.FlxG;
import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * Yoinked from WTFEngine
 * https://github.com/VirtuGuy/WTF-Engine/blob/main/source/funkin/Conductor.hx
 */
class RhythmManager
{
	public static final MS_PER_SEC:Int = 1000;
	public static final SECS_PER_MIN:Int = 60;
	public static final PIXELS_PER_MS:Float = 0.45;
	public static final STEPS_PER_BEAT:Int = 4;

	public static var instance:RhythmManager;

	public var time:Float;
	public var bpm(default, set):Float;

	public var step:Int;
	public var beat:Int;

	public var crotchet(get, never):Float;
	public var quaver(get, never):Float;

	public var stepHit(default, null) = new FlxTypedSignal<Int->Void>();
	public var beatHit(default, null) = new FlxTypedSignal<Int->Void>();

	var changeStep:Int = 0;
	var changeTimestamp:Float = 0;

	public function new() {}

	public function update()
	{
		final lastStep:Int = step;
		final lastBeat:Int = beat;

		step = changeStep + Math.floor((time - changeTimestamp) / quaver);
		beat = Math.floor(step / RhythmManager.STEPS_PER_BEAT);

		if (lastStep != step)
			stepHit.dispatch(step);
		if (lastBeat != beat)
			beatHit.dispatch(beat);

		// Debug watching (for debugging purposes)
		FlxG.watch.addQuick('time', time);
		FlxG.watch.addQuick('bpm', bpm);
		FlxG.watch.addQuick('step', step);
		FlxG.watch.addQuick('beat', beat);
	}

	/**
	 * Resets everything, including time, BPM, and steps.
	 * You're going to want to run this whenever music is changed.
	 */
	public function reset(bpm:Float = 0)
	{
		this.bpm = bpm;

		time = 0;

		step = 0;
		beat = 0;

		changeStep = 0;
		changeTimestamp = 0;
	}

	function set_bpm(value:Float):Float
	{
		if (this.bpm == value)
			return value;
		this.bpm = value;

		changeStep = step;
		changeTimestamp = time;

		return value;
	}

	inline function get_crotchet():Float
		return RhythmManager.SECS_PER_MIN / bpm * RhythmManager.MS_PER_SEC;

	inline function get_quaver():Float
		return crotchet / RhythmManager.STEPS_PER_BEAT;
}
