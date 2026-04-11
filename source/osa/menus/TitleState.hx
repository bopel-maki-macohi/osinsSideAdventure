package osa.menus;

import osa.shaders.GrayscaleShader;
import osa.visualnovel.VNState;
import osa.objects.ClickableSprite;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import openfl.filters.BlurFilter;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import osa.objects.TileScrollBG;
import flixel.FlxState;

class TitleState extends OSAState
{
	public var _tileScrollBG:TileScrollBG;

	public var _logo:FlxSprite;

	public var _blurFilterBG:BlurFilter;
	public var _blurFilterFG:BlurFilter;

	public var _blurCamBG:FlxCamera;
	public var _blurCamFG:FlxCamera;

	public var _playBtn:ClickableSprite;
	public var _optionsBtn:ClickableSprite;
	public var _creditsBtn:ClickableSprite;

	override function create()
	{
		_tileScrollBG = new TileScrollBG(FlxPoint.get(25, 25), true);

		_logo = new FlxSprite(0, 0, 'logo'.imageFile().menuAsset());
		_logo.screenCenter();

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
		_logo.camera = _blurCamFG;

		add(_tileScrollBG);
		add(_logo);

		_playBtn = new ClickableSprite(0, 0, 'title/play'.menuAsset().imageFile());
		_optionsBtn = new ClickableSprite(0, 0, 'title/options'.menuAsset().imageFile());
		_creditsBtn = new ClickableSprite(0, 0, 'title/credits'.menuAsset().imageFile());

		for (btn in [_playBtn, _optionsBtn, _creditsBtn])
		{
			btn.scale.set(0.5, 0.5);

			btn.updateHitbox();
			btn.screenCenter();

			btn.cameras = [_blurCamFG];

			btn._overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(btn, 0.6, 0.5));
			btn._unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(btn, 0.5, 0.5));
		}

		_playBtn.x = 128;
		_optionsBtn.y = FlxG.height - _optionsBtn.height - (_playBtn.x / 4);
		_creditsBtn.x = FlxG.width - _creditsBtn.width - _playBtn.x;

		add(_playBtn);
		add(_optionsBtn);
		add(_creditsBtn);

		_playBtn._onClick.add(onPlay);
		_optionsBtn._onClick.add(onOptions);
		_creditsBtn._onClick.add(onCredits);

		_optionsBtn.shader = new GrayscaleShader(.75);

		persistentUpdate = true;

		super.create();

		#if DISABLE_TITLE_WATERMARK_BLUR
		var regCam = new FlxCamera();
		FlxG.cameras.add(regCam, false);
		regCam.bgColor.alpha = 0;

		_watermark.camera = regCam;
		#end
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
		if (FlxG.keys.justPressed.SPACE)
			FlxG.switchState(() -> new TitleState());
	}

	function onPlay()
	{
		FlxG.switchState(() -> new VNState('intro'));
	}

	function onOptions() {}

	function onCredits() {}
}
