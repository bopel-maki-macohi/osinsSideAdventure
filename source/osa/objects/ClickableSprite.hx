package osa.objects;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.FlxSprite;

class ClickableSprite extends FlxSprite
{
	public static function overlapUpdateScale(sprite:ClickableSprite, ?scale:Float = 1.1, ?lerp:Float = 0.04)
	{
		sprite.scale.x = FlxMath.lerp(sprite.scale.x, scale, lerp);
		sprite.scale.y = FlxMath.lerp(sprite.scale.y, scale, lerp);
	}

	public static function unoverlapUpdateScale(sprite:ClickableSprite, ?scale:Float = 1.0, ?lerp:Float = 0.04)
	{
		sprite.scale.x = FlxMath.lerp(sprite.scale.x, scale, lerp);
		sprite.scale.y = FlxMath.lerp(sprite.scale.y, scale, lerp);
	}

	public var _overlapUpdate:FlxSignal = new FlxSignal();
	public var _unoverlapUpdate:FlxSignal = new FlxSignal();
	public var _onClick:FlxSignal = new FlxSignal();

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(this))
		{
			_overlapUpdate.dispatch();
			if (FlxG.mouse.justPressed)
				_onClick.dispatch();
		}
		else
		{
			_unoverlapUpdate.dispatch();
		}
	}
}
