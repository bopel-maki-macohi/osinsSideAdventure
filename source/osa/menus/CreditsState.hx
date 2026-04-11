package osa.menus;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxCamera;
import openfl.filters.BlurFilter;
import flixel.math.FlxPoint;
import osa.objects.TileScrollBG;

class CreditsState extends OSAState
{
	public var _tileScrollBG:TileScrollBG;

	public var _blurFilterBG:BlurFilter;
	public var _blurFilterFG:BlurFilter;

	public var _blurCamBG:FlxCamera;
	public var _blurCamFG:FlxCamera;

	override function create()
	{
		_tileScrollBG = new TileScrollBG(FlxPoint.get(25, 25), true, 'credits');

		add(_tileScrollBG);

		_blurFilterBG = new BlurFilter(_blurUnfocus, _blurUnfocus, 1);
		_blurFilterFG = new BlurFilter(_blurFocus, _blurFocus, 1);

		_blurCamBG = new FlxCamera();
		FlxG.cameras.add(_blurCamBG);

		_blurCamFG = new FlxCamera();
		FlxG.cameras.add(_blurCamFG);
		_blurCamFG.bgColor.alpha = 0;
		_blurCamFG.y -= _blurCamFG.height / 10;

		_blurCamBG.filters = [_blurFilterBG];
		_blurCamFG.filters = [_blurFilterFG];

        _tileScrollBG.camera = _blurCamBG;

		super.create();
	}

	final _blurFocus:Float = 0;
	final _blurUnfocus:Float = 4;
	final _blurFocusChangeSpeed:Float = 0.04;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_tileScrollBG._debugModeInUse)
		{
			_blurFilterBG.blurX = FlxMath.lerp(_blurFilterBG.blurX, _blurFocus, _blurFocusChangeSpeed);
			_blurFilterBG.blurY = FlxMath.lerp(_blurFilterBG.blurY, _blurFocus, _blurFocusChangeSpeed);

			_blurFilterFG.blurX = FlxMath.lerp(_blurFilterFG.blurX, _blurUnfocus, _blurFocusChangeSpeed);
			_blurFilterFG.blurY = FlxMath.lerp(_blurFilterFG.blurY, _blurUnfocus, _blurFocusChangeSpeed);
			_blurCamFG.alpha = FlxMath.lerp(_blurCamFG.alpha, 0.15, _blurFocusChangeSpeed);
		}
		else
		{
			_blurFilterBG.blurX = FlxMath.lerp(_blurFilterBG.blurX, _blurUnfocus, _blurFocusChangeSpeed);
			_blurFilterBG.blurY = FlxMath.lerp(_blurFilterBG.blurY, _blurUnfocus, _blurFocusChangeSpeed);

			_blurFilterFG.blurX = FlxMath.lerp(_blurFilterFG.blurX, _blurFocus, _blurFocusChangeSpeed);
			_blurFilterFG.blurY = FlxMath.lerp(_blurFilterFG.blurY, _blurFocus, _blurFocusChangeSpeed);
			_blurCamFG.alpha = FlxMath.lerp(_blurCamFG.alpha, 1, _blurFocusChangeSpeed);

			controls();
		}
	}

	function controls()
	{
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new TitleState());
	}
}
