package osa.objects;

import flixel.math.FlxPoint;
import flixel.addons.display.FlxBackdrop;

class TileScrollBG extends FlxBackdrop
{
	override public function new(velocity:FlxPoint)
	{
		super('tile'.imageFile().menuAsset());

		this.velocity = velocity;
	}
}
