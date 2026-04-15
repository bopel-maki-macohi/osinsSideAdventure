package osa.objects;

import osa.util.Controls;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxBackdrop;

class TileScrollBG extends FlxBackdrop
{
	public var _debugMode:Bool = false;

	public var _debugModeInUse(default, null):Bool = false;

	public var _tile(default, set):String;

	function set__tile(tile:String):String
	{
		loadGraphic(tile.imageFile());
		return tile;
	}

	override public function new(velocity:FlxPoint, debugMode:Bool = false)
	{
		super();

		this._tile = 'tile'.menuAsset();

		this.velocity = velocity;

		this._debugMode = debugMode;
	}

	public var _parent:TileScrollBG;

	public static function build(velocity:FlxPoint, ?tile:String, ?parent:TileScrollBG, ?debugMode:Bool = false):TileScrollBG
	{
		var tsb:TileScrollBG = new TileScrollBG(velocity ?? FlxPoint.get(), debugMode && parent == null);

		if (tile != null)
			tsb._tile = tile;
		if (parent != null)
		{
			tsb._parent = parent;

			tsb.cameras = parent.cameras;
		}

		return tsb;
	}

	public var _debugVelocityChangeValue:Float = 5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_parent != null)
		{
			this.velocity.x = _parent.velocity.x;
			this.velocity.y = _parent.velocity.y;
		}

		if (_debugMode && _parent == null)
		{
			_debugModeInUse = Controls.instance.pressed.TILE_SCROLLING_BG_DEBUGMODE;

			if (_debugModeInUse)
			{
				if (Controls.instance.pressed.LEFT)
					this.velocity.x -= _debugVelocityChangeValue;
				if (Controls.instance.pressed.RIGHT)
					this.velocity.x += _debugVelocityChangeValue;

				if (Controls.instance.pressed.DOWN)
					this.velocity.y += _debugVelocityChangeValue;
				if (Controls.instance.pressed.UP)
					this.velocity.y -= _debugVelocityChangeValue;
			}
		}
	}
}
