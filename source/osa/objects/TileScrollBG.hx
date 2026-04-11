package osa.objects;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxBackdrop;

class TileScrollBG extends FlxBackdrop
{
	public var _debugMode:Bool = false;

	public var _debugModeInUse(default, null):Bool = false;

	override public function new(velocity:FlxPoint, debugMode:Bool = false)
	{
		super('tile'.imageFile().menuAsset());

		this.velocity = velocity;

		this._debugMode = debugMode;
	}

	public var _debugVelocityChangeValue:Float = 5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_debugMode)
		{
			_debugModeInUse = FlxG.keys.anyPressed([W, A, S, D, LEFT, DOWN, UP, RIGHT]);

			if (FlxG.keys.anyPressed([A, LEFT]))
				this.velocity.x -= _debugVelocityChangeValue;
			if (FlxG.keys.anyPressed([D, RIGHT]))
				this.velocity.x += _debugVelocityChangeValue;

			if (FlxG.keys.anyPressed([S, DOWN]))
				this.velocity.y += _debugVelocityChangeValue;
			if (FlxG.keys.anyPressed([W, UP]))
				this.velocity.y -= _debugVelocityChangeValue;
		}
	}
}
