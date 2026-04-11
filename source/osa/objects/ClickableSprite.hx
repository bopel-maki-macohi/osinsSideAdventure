package osa.objects;

import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.FlxSprite;

class ClickableSprite extends FlxSprite
{
	public var _overlapUpdate:FlxSignal = new FlxSignal();
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
	}
}
