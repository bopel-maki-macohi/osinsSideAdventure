package flxnovel.objects;

import flixel.util.FlxColor;
import flixel.addons.display.FlxRadialGauge;

using flxnovel.util.FloatUtil;

/**
 * Base code yoinked from FNF "AttractState"
 */
class HoldToPerformGadge extends FlxRadialGauge
{
	/**
	 * Duration you need to touch for to perform.
	 */
	public static final HOLD_TIME:Float = 1.5;

	var holdDelta:Float = 0;

	public var onComplete:Void->Void;
	public var condition:Void->Bool;

	override public function new(primaryColor:FlxColor, condition:Void->Bool, ?onComplete:Void->Void)
	{
		super();

		makeShapeGraphic(CIRCLE, 40, 20, primaryColor ?? FlxColor.WHITE);
		amount = 0;

		this.onComplete = onComplete;
		this.condition = condition;

		this.antialiasing = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((condition != null && condition()))
			holdDelta += elapsed;
		else
			holdDelta = holdDelta.lerp(-0.1, (elapsed * 3).clamp(0, 1));

		holdDelta = holdDelta.clamp(0, HoldToPerformGadge.HOLD_TIME);
		amount = Math.min(1, Math.max(0, (holdDelta / HoldToPerformGadge.HOLD_TIME) * 1.025));
		scale.x = scale.y = 1.lerp(1.3, amount).clamp(1, 1.3);
		alpha = 0.lerp(1, amount).clamp(0, 1);

		// If the dial is full, skip the video.
		if (amount >= 1 && onComplete != null)
			onComplete();
	}
}
