package osa.objects;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.display.FlxRadialGauge;

using osa.util.FloatUtil;

/**
 * Base code yoinked from FNF "AttractState"
 */
class HoldToPerformGadge extends FlxRadialGauge
{
	/**
	 * Duration you need to touch for to perform.
	 */
	public static final HOLD_TIME:Float = 1.5;

	var _holdDelta:Float = 0;

	public var _onComplete:Void->Void;
	public var _condition:Void->Bool;

	override public function new(primaryColor:FlxColor, condition:Void->Bool, ?onComplete:Void->Void)
	{
		super();

		makeShapeGraphic(CIRCLE, 40, 20, primaryColor ?? FlxColor.WHITE);
		amount = 0;

		this._onComplete = onComplete;
		this._condition = condition;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((_condition != null && _condition()))
			_holdDelta += elapsed;
		else
			_holdDelta = FlxMath.lerp(_holdDelta, -0.1, (elapsed * 3).clamp(0, 1));

		_holdDelta = _holdDelta.clamp(0, HoldToPerformGadge.HOLD_TIME);
		amount = Math.min(1, Math.max(0, (_holdDelta / HoldToPerformGadge.HOLD_TIME) * 1.025));
		scale.x = scale.y = FlxMath.lerp(1, 1.3, amount).clamp(1, 1.3);
		alpha = FlxMath.lerp(0, 1, amount).clamp(0, 1);

		// If the dial is full, skip the video.
		if (amount >= 1 && _onComplete != null)
			_onComplete();
	}
}
