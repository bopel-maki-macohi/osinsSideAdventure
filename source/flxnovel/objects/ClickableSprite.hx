package flxnovel.objects;

import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.FlxSprite;

class ClickableSprite extends FlxSprite
{
	public static function overlapUpdateScale(sprite:ClickableSprite, ?scale:Float = 1.1, ?lerp:Float = 0.04)
	{
		sprite.scale.x = sprite.scale.x.lerp(scale, lerp);
		sprite.scale.y = sprite.scale.y.lerp(scale, lerp);
	}

	public static function unoverlapUpdateScale(sprite:ClickableSprite, ?scale:Float = 1.0, ?lerp:Float = 0.04)
	{
		overlapUpdateScale(sprite, scale, lerp);
	}

	public var overlapUpdate:FlxSignal = new FlxSignal();
	public var unoverlapUpdate:FlxSignal = new FlxSignal();
	public var onClick:FlxSignal = new FlxSignal();

	public var useMouse:Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (useMouse)
			if (FlxG.mouse.overlaps(this) && alpha > 0)
			{
				overlapUpdate.dispatch();
				if (FlxG.mouse.justPressed)
					onClick.dispatch();
			}
			else
			{
				unoverlapUpdate.dispatch();
			}
	}
}
