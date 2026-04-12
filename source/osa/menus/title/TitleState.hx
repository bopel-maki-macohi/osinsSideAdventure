package osa.menus.title;

import osa.menus.title.options.OptionsSubState;
import osa.util.Constants;
import osa.menus.storymenu.StoryMenuState;
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
	public var _optionsTileScrollBG:TileScrollBG;

	public var _logo:FlxSprite;

	public var _blurFilterBG:BlurFilter;
	public var _blurFilterFG:BlurFilter;

	public static var blurCamBG:FlxCamera;
	public static var blurCamFG:FlxCamera;

	public var _playBtn:ClickableSprite;
	public var _optionsBtn:ClickableSprite;
	public var _creditsBtn:ClickableSprite;

	public static var bgScrolling:Bool = false;

	override function create()
	{
		_titleTileScrollBG = new TileScrollBG(FlxPoint.get(25, 25), true);

		_creditsTileScrollBG = new TileScrollBG(FlxPoint.get(), false,);
		_creditsTileScrollBG._tile = 'tile-tirok'.menuAsset();
		_creditsTileScrollBG.alpha = 0;

		_optionsTileScrollBG = new TileScrollBG(FlxPoint.get(), false,);
		_optionsTileScrollBG._tile = 'tile-loroc'.menuAsset();
		_optionsTileScrollBG.alpha = 0;

		_logo = new FlxSprite(0, 0, 'logo'.imageFile().menuAsset());
		_logo.screenCenter();

		_blurFilterBG = new BlurFilter(Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_UNFOCUS, 1);
		_blurFilterFG = new BlurFilter(Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUS, 1);

		blurCamBG = new FlxCamera();
		FlxG.cameras.add(blurCamBG);

		blurCamFG = new FlxCamera();
		FlxG.cameras.add(blurCamFG);
		blurCamFG.bgColor.alpha = 0;

		blurCamBG.filters = [_blurFilterBG];
		blurCamFG.filters = [_blurFilterFG];

		_titleTileScrollBG.camera = blurCamBG;
		_creditsTileScrollBG.camera = blurCamBG;
		_optionsTileScrollBG.camera = blurCamBG;

		_logo.camera = blurCamFG;

		add(_titleTileScrollBG);
		add(_creditsTileScrollBG);
		add(_optionsTileScrollBG);

		add(_logo);

		_playBtn = new ClickableSprite(0, 0, 'title/play'.menuAsset().imageFile());
		_optionsBtn = new ClickableSprite(0, 0, 'title/options'.menuAsset().imageFile());
		_creditsBtn = new ClickableSprite(0, 0, 'title/credits'.menuAsset().imageFile());

		for (btn in [_playBtn, _optionsBtn, _creditsBtn])
		{
			btn.scale.set(0.5, 0.5);

			btn.updateHitbox();
			btn.screenCenter();

			btn.cameras = [blurCamFG];

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

		// _optionsBtn.shader = new GrayscaleShader(.75);

		persistentUpdate = true;

		for (obj in this.members)
		{
			if (obj.cameras.contains(blurCamFG))
			{
				if (Reflect.field(obj, 'y') != null)
					Reflect.setProperty(obj, 'y', Reflect.field(obj, 'y') - blurCamFG.height / 10);
			}
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		bgScrolling = _titleTileScrollBG._debugModeInUse;
		if (bgScrolling)
		{
			_blurFilterBG.blurX = FlxMath.lerp(_blurFilterBG.blurX, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);
			_blurFilterBG.blurY = FlxMath.lerp(_blurFilterBG.blurY, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);

			_blurFilterFG.blurX = FlxMath.lerp(_blurFilterFG.blurX, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);
			_blurFilterFG.blurY = FlxMath.lerp(_blurFilterFG.blurY, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);
			blurCamFG.alpha = FlxMath.lerp(blurCamFG.alpha, 0.15, Constants.DEFAULT_LERP_SPEED);
		}
		else
		{
			_blurFilterBG.blurX = FlxMath.lerp(_blurFilterBG.blurX, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);
			_blurFilterBG.blurY = FlxMath.lerp(_blurFilterBG.blurY, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);

			_blurFilterFG.blurX = FlxMath.lerp(_blurFilterFG.blurX, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);
			_blurFilterFG.blurY = FlxMath.lerp(_blurFilterFG.blurY, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);
			blurCamFG.alpha = FlxMath.lerp(blurCamFG.alpha, 1, Constants.DEFAULT_LERP_SPEED);

			controls();
		}

		_creditsTileScrollBG.velocity.set(_titleTileScrollBG.velocity.x, _titleTileScrollBG.velocity.y);
		_optionsTileScrollBG.velocity.set(_titleTileScrollBG.velocity.x, _titleTileScrollBG.velocity.y);
	}

	function controls()
	{
		if (FlxG.keys.justPressed.SPACE && subState == null)
			FlxG.switchState(() -> new TitleState());
	}

	function onPlay()
	{
		FlxG.switchState(() -> new StoryMenuState());
	}

	function onOptions()
	{
		onSubStateEnter();

		FlxTween.cancelTweensOf(_optionsTileScrollBG);
		FlxTween.tween(_optionsTileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});

		openSubState(new OptionsSubState(onOptionsExit));
	}

	function onCredits()
	{
		onSubStateEnter();

		FlxTween.cancelTweensOf(_creditsTileScrollBG);
		FlxTween.tween(_creditsTileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});

		openSubState(new CreditsSubState(onCreditsExit));
	}

	function onSubStateEnter()
	{
		for (spr in [_logo, _playBtn, _creditsBtn, _optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 0}, this.transIn.duration, {ease: FlxEase.sineInOut});
		}
	}

	function onSubStateExit()
	{
		for (spr in [_logo, _playBtn, _creditsBtn, _optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}
	}

	public function onCreditsExit()
	{
		onSubStateExit();

		FlxTween.cancelTweensOf(_creditsTileScrollBG);
		FlxTween.tween(_creditsTileScrollBG, {alpha: 0}, this.transOut.duration, {ease: FlxEase.sineInOut});
	}

	public function onOptionsExit()
	{
		onSubStateExit();

		FlxTween.cancelTweensOf(_optionsTileScrollBG);
		FlxTween.tween(_optionsTileScrollBG, {alpha: 0}, this.transOut.duration, {ease: FlxEase.sineInOut});
	}

	override function onExit()
	{
		super.onExit();

		bgScrolling = false;
	}
}
