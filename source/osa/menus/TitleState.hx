package osa.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
	public var _titleTileScrollBG:TileScrollBG;
	public var _creditsTileScrollBG:TileScrollBG;

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
		_titleTileScrollBG = new TileScrollBG(FlxPoint.get(25, 25), true);
		
		_creditsTileScrollBG = new TileScrollBG(FlxPoint.get(), false,);
		_creditsTileScrollBG._tile = 'tile-credits'.menuAsset();
		_creditsTileScrollBG.alpha = 0;

		_logo = new FlxSprite(0, 0, 'logo'.imageFile().menuAsset());
		_logo.screenCenter();

		_blurFilterBG = new BlurFilter(_blurUnfocus, _blurUnfocus, 1);
		_blurFilterFG = new BlurFilter(_blurFocus, _blurFocus, 1);

		_blurCamBG = new FlxCamera();
		FlxG.cameras.add(_blurCamBG);

		_blurCamFG = new FlxCamera();
		FlxG.cameras.add(_blurCamFG);
		_blurCamFG.bgColor.alpha = 0;

		_blurCamBG.filters = [_blurFilterBG];
		_blurCamFG.filters = [_blurFilterFG];

		_titleTileScrollBG.camera = _blurCamBG;
		_creditsTileScrollBG.camera = _blurCamBG;
		_logo.camera = _blurCamFG;

		add(_titleTileScrollBG);
		add(_creditsTileScrollBG);
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

		for (obj in this.members)
		{
			if (obj.cameras.contains(_blurCamFG))
			{
				if (Reflect.field(obj, 'y') != null)
					Reflect.setProperty(obj, 'y', Reflect.field(obj, 'y') - _blurCamFG.height / 10);
			}
		}

		super.create();
	}

	final _blurFocus:Float = 0;
	final _blurUnfocus:Float = 4;
	final _blurFocusChangeSpeed:Float = 0.04;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_titleTileScrollBG._debugModeInUse)
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

		_creditsTileScrollBG.velocity.set(_titleTileScrollBG.velocity.x, _titleTileScrollBG.velocity.y);
	}

	function controls()
	{
		if (FlxG.keys.justPressed.SPACE && subState == null)
			FlxG.switchState(() -> new TitleState());
	}

	function onPlay()
	{
		FlxG.switchState(() -> new VNState('intro'));
	}

	function onOptions() {}

	function onCredits()
	{
		for (spr in [_logo, _playBtn, _creditsBtn, _optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 0}, this.transIn.duration, {ease: FlxEase.sineInOut});
		}

		FlxTween.cancelTweensOf(_creditsTileScrollBG);
		FlxTween.tween(_creditsTileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});

		openSubState(new CreditsSubState(onCreditsExit));
	}

	public function onCreditsExit()
	{
		for (spr in [_logo, _playBtn, _creditsBtn, _optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		FlxTween.cancelTweensOf(_creditsTileScrollBG);
		FlxTween.tween(_creditsTileScrollBG, {alpha: 0}, this.transOut.duration, {ease: FlxEase.sineInOut});
	}
}
