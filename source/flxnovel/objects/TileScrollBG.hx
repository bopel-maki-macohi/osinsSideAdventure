package flxnovel.objects;

import flxnovel.util.Controls;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxBackdrop;

class TileScrollBG extends FlxBackdrop
{
	public var debugMode:Bool = false;

	public var debugModeInUse(default, null):Bool = false;

	public var tile(default, set):String;

	function set_tile(tile:String):String
	{
		loadGraphic(tile.imageFile());
		return tile;
	}

	override public function new(velocity:FlxPoint, debugMode:Bool = false)
	{
		super();

		this.tile = 'tiles/tile'.menuAsset();

		this.velocity = velocity;

		this.debugMode = debugMode;
	}

	public var parent:TileScrollBG;

	public static function build(velocity:FlxPoint, ?tile:String, ?parent:TileScrollBG, ?debugMode:Bool = false):TileScrollBG
	{
		var tsb:TileScrollBG = new TileScrollBG(velocity ?? FlxPoint.get(), debugMode && parent == null);

		if (tile != null)
			tsb.tile = tile;

		if (parent != null)
		{
			tsb.parent = parent;

			tsb.cameras = parent.cameras;
		}

		return tsb;
	}

	public var debugVelocityChangeValue:Float = 5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (parent != null)
		{
			this.velocity.x = parent.velocity.x;
			this.velocity.y = parent.velocity.y;
		}

		if (debugMode && parent == null)
		{
			debugModeInUse = FlxG.keys.pressed.SHIFT;

			if (debugModeInUse)
			{
				if (Controls.instance.pressed.LEFT)
					this.velocity.x -= debugVelocityChangeValue;
				if (Controls.instance.pressed.RIGHT)
					this.velocity.x += debugVelocityChangeValue;

				if (Controls.instance.pressed.DOWN)
					this.velocity.y += debugVelocityChangeValue;
				if (Controls.instance.pressed.UP)
					this.velocity.y -= debugVelocityChangeValue;
			}
		}
	}
}
