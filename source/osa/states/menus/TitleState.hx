package osa.states.menus;

import flixel.util.FlxTimer;
import flixel.FlxSubState;
import osa.util.Constants;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import osa.shaders.GrayscaleShader;
import osa.states.visualnovel.VNState;
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

	public var _storymenuTileScrollBG:TileScrollBG;
	public var _debugTileScrollBG:TileScrollBG;
	public var _creditsTileScrollBG:TileScrollBG;
	public var _optionsTileScrollBG:TileScrollBG;

	public var _logo:FlxSprite;

	public var _blurFilterBG:BlurFilter;
	public var _blurFilterFG:BlurFilter;

	public static var blurCamBG:FlxCamera;
	public static var blurCamFG:FlxCamera;

	public var _storymenuBtn:ClickableSprite;
	public var _optionsBtn:ClickableSprite;
	public var _creditsBtn:ClickableSprite;

	public static var bgScrolling:Bool = false;

	public var _targetState:String = null;

	override public function new(?targetState:String)
	{
		super();

		this._targetState = targetState;
	}

	override function create()
	{
		_titleTileScrollBG = new TileScrollBG(FlxPoint.get(25, 25), true);

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

		_logo.camera = blurCamFG;

		add(_titleTileScrollBG);
		
		_debugTileScrollBG = TileScrollBG.build(null, 'tile-sinco'.menuAsset(), _titleTileScrollBG);
		_debugTileScrollBG.alpha = 0;

		_storymenuTileScrollBG = TileScrollBG.build(null, 'tile-osin'.menuAsset(), _titleTileScrollBG);
		_storymenuTileScrollBG.alpha = 0;

		_creditsTileScrollBG = TileScrollBG.build(null, 'tile-tirok'.menuAsset(), _titleTileScrollBG);
		_creditsTileScrollBG.alpha = 0;

		_optionsTileScrollBG = TileScrollBG.build(null, 'tile-loroc'.menuAsset(), _titleTileScrollBG);
		_optionsTileScrollBG.alpha = 0;

		add(_debugTileScrollBG);
		add(_storymenuTileScrollBG);
		add(_creditsTileScrollBG);
		add(_optionsTileScrollBG);

		add(_logo);

		_storymenuBtn = new ClickableSprite(0, 0, 'title/play'.menuAsset().imageFile());
		_optionsBtn = new ClickableSprite(0, 0, 'title/options'.menuAsset().imageFile());
		_creditsBtn = new ClickableSprite(0, 0, 'title/credits'.menuAsset().imageFile());

		for (btn in [_storymenuBtn, _optionsBtn, _creditsBtn])
		{
			btn.scale.set(0.5, 0.5);

			btn.updateHitbox();
			btn.screenCenter();

			btn.cameras = [blurCamFG];

			btn._overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(btn, 0.6, 0.5));
			btn._unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(btn, 0.5, 0.5));
		}

		_storymenuBtn.x = 128;
		_optionsBtn.y = FlxG.height - _optionsBtn.height - (_storymenuBtn.x / 4);
		_creditsBtn.x = FlxG.width - _creditsBtn.width - _storymenuBtn.x;

		add(_storymenuBtn);
		add(_optionsBtn);
		add(_creditsBtn);

		_storymenuBtn._onClick.add(() -> onSelectionClicked(_storymenuTileScrollBG, new StoryMenuSubState(() -> onSelectionExited(_storymenuTileScrollBG))));
		_optionsBtn._onClick.add(() -> onSelectionClicked(_optionsTileScrollBG, new OptionsSubState(() -> onSelectionExited(_optionsTileScrollBG))));
		_creditsBtn._onClick.add(() -> onSelectionClicked(_creditsTileScrollBG, new CreditsSubState(() -> onSelectionExited(_creditsTileScrollBG))));

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

		FlxG.mouse.visible = true;

		super.create();

		var TSFunc:Void->Void = null;

		switch (_targetState?.toLowerCase())
		{
			case 'storymenu':
				TSFunc = () -> _storymenuBtn._onClick.dispatch();
			case 'credits':
				TSFunc = () -> _creditsBtn._onClick.dispatch();
			case 'optionsmenu':
				TSFunc = () -> _optionsBtn._onClick.dispatch();
			case 'debugmenu':
				TSFunc = debugSubState;
		}

		if (TSFunc != null)
		{
			FlxG.mouse.visible = false;

			for (obj in [_storymenuBtn, _optionsBtn, _creditsBtn, _logo, _titleTileScrollBG,])
				obj.alpha = 0;

			FlxTimer.wait(transIn.duration, () ->
			{
				TSFunc();
			});
		}
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

		if (FlxG.keys.justReleased.SEVEN && subState == null)
			debugSubState();
	}

	function debugSubState()
	{
		onSelectionClicked(_debugTileScrollBG, new DebugSubState(() -> onSelectionExited(_debugTileScrollBG)));
	}

	function controls()
	{
		if (FlxG.keys.justPressed.SPACE && subState == null)
			FlxG.switchState(() -> new TitleState());
	}

	function onSelectionClicked(tileScrollBG:TileScrollBG, substate:OSASubState)
	{
		for (spr in [_logo, _storymenuBtn, _creditsBtn, _optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 0}, this.transIn.duration, {ease: FlxEase.sineInOut});
		}

		if (tileScrollBG != null)
		{
			FlxTween.cancelTweensOf(tileScrollBG);
			FlxTween.tween(tileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		openSubState(substate);
	}

	function onSelectionExited(tileScrollBG:TileScrollBG)
	{
		for (spr in [_logo, _storymenuBtn, _creditsBtn, _optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		if (_titleTileScrollBG.alpha < 1)
		{
			FlxTween.cancelTweensOf(_titleTileScrollBG);
			FlxTween.tween(_titleTileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		FlxG.mouse.visible = true;

		if (tileScrollBG != null)
		{
			FlxTween.cancelTweensOf(tileScrollBG);
			FlxTween.tween(tileScrollBG, {alpha: 0}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}
	}

	override function onExit()
	{
		super.onExit();

		bgScrolling = false;
	}
}
