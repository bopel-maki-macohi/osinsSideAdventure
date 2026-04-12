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

	public var _time:Float;
	public var _bpm(default, set):Float;

	public var _step:Int;
	public var _beat:Int;

	public var _crotchet(get, never):Float;
	public var _quaver(get, never):Float;

	public var _stepHit(default, null) = new FlxTypedSignal<Int->Void>();
	public var _beatHit(default, null) = new FlxTypedSignal<Int->Void>();

	var _changeStep:Int = 0;
	var _changeTimestamp:Float = 0;

	public function new() {}

	public function update()
	{
		final lastStep:Int = _step;
		final lastBeat:Int = _beat;

		_step = _changeStep + Math.floor((_time - _changeTimestamp) / _quaver);
		_beat = Math.floor(_step / RhythmManager.STEPS_PER_BEAT);

		if (lastStep != _step)
			_stepHit.dispatch(_step);
		if (lastBeat != _beat)
			_beatHit.dispatch(_beat);

		// Debug watching (for debugging purposes)
		FlxG.watch.addQuick('time', _time);
		FlxG.watch.addQuick('bpm', _bpm);
		FlxG.watch.addQuick('step', _step);
		FlxG.watch.addQuick('beat', _beat);
	}

	/**
	 * Resets everything, including time, BPM, and steps.
	 * You're going to want to run this whenever music is changed.
	 */
	public function reset(bpm:Float = 0)
	{
		this._bpm = bpm;

		_time = 0;

		_step = 0;
		_beat = 0;

		_changeStep = 0;
		_changeTimestamp = 0;
	}

	function set__bpm(value:Float):Float
	{
		if (this._bpm == value)
			return value;
		this._bpm = value;

		_changeStep = _step;
		_changeTimestamp = _time;

		return value;
	}

	inline function get__crotchet():Float
		return RhythmManager.SECS_PER_MIN / _bpm * RhythmManager.MS_PER_SEC;

	inline function get__quaver():Float
		return _crotchet / RhythmManager.STEPS_PER_BEAT;
}
