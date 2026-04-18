package osa.states.menus;

import osa.util.SoundUtil;
import osa.shaders.GrayscaleShader;
import flixel.util.FlxTimer;
import osa.util.Constants;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import osa.objects.ClickableSprite;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import openfl.filters.BlurFilter;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import osa.objects.TileScrollBG;

class TitleState extends OSAState
{
	public var titleTileScrollBG:TileScrollBG;

	public var storymenuTileScrollBG:TileScrollBG;
	public var debugTileScrollBG:TileScrollBG;
	public var creditsTileScrollBG:TileScrollBG;
	public var optionsTileScrollBG:TileScrollBG;

	public var logo:FlxSprite;

	public var blurFilterBG:BlurFilter;
	public var blurFilterFG:BlurFilter;

	public static var blurCamBG:FlxCamera;
	public static var blurCamFG:FlxCamera;

	public var storymenuBtn:ClickableSprite;
	public var optionsBtn:ClickableSprite;
	public var creditsBtn:ClickableSprite;

	public static var bgScrolling:Bool = false;

	public var targetState:String = null;

	override public function new(?targetState:String)
	{
		super();

		this.targetState = targetState;
	}

	override function create()
	{
		titleTileScrollBG = TileScrollBG.build(FlxPoint.get(25, 25), null, null, true);

		logo = new FlxSprite(0, 0, 'logo'.imageFile().menuAsset());
		logo.screenCenter();

		blurFilterBG = new BlurFilter(Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_UNFOCUS, 1);
		blurFilterFG = new BlurFilter(Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUS, 1);

		blurCamBG = new FlxCamera();
		FlxG.cameras.add(blurCamBG);

		blurCamFG = new FlxCamera();
		FlxG.cameras.add(blurCamFG);
		blurCamFG.bgColor.alpha = 0;

		blurCamBG.filters = [blurFilterBG];
		blurCamFG.filters = [blurFilterFG];

		titleTileScrollBG.camera = blurCamBG;

		logo.camera = blurCamFG;

		add(titleTileScrollBG);

		debugTileScrollBG = TileScrollBG.build(null, 'tiles/tile-sinco'.menuAsset(), titleTileScrollBG);
		debugTileScrollBG.alpha = 0;

		storymenuTileScrollBG = TileScrollBG.build(null, 'tiles/tile-osin'.menuAsset(), titleTileScrollBG);
		storymenuTileScrollBG.alpha = 0;

		creditsTileScrollBG = TileScrollBG.build(null, 'tiles/tile-tirok'.menuAsset(), titleTileScrollBG);
		creditsTileScrollBG.alpha = 0;

		optionsTileScrollBG = TileScrollBG.build(null, 'tiles/tile-loroc'.menuAsset(), titleTileScrollBG);
		optionsTileScrollBG.alpha = 0;

		add(debugTileScrollBG);
		add(storymenuTileScrollBG);
		add(creditsTileScrollBG);
		add(optionsTileScrollBG);

		add(logo);

		storymenuBtn = new ClickableSprite(0, 0, 'title/play'.menuAsset().imageFile());
		optionsBtn = new ClickableSprite(0, 0, 'title/options'.menuAsset().imageFile());
		creditsBtn = new ClickableSprite(0, 0, 'title/credits'.menuAsset().imageFile());

		for (btn in [storymenuBtn, optionsBtn, creditsBtn])
		{
			btn.scale.set(0.5, 0.5);

			btn.updateHitbox();
			btn.screenCenter();

			btn.cameras = [blurCamFG];

			btn.overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(btn, 0.6, 0.5));
			btn.unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(btn, 0.5, 0.5));
		}

		storymenuBtn.x = 128;
		optionsBtn.y = FlxG.height - optionsBtn.height - (storymenuBtn.x / 4);
		creditsBtn.x = FlxG.width - creditsBtn.width - storymenuBtn.x;

		storymenuBtn.shader = new GrayscaleShader(.75);

		add(storymenuBtn);
		add(optionsBtn);
		add(creditsBtn);

		// storymenuBtn._onClick.add(() -> onSelectionClicked(storymenuTileScrollBG, new StoryMenuSubState(() -> onSelectionExited(storymenuTileScrollBG))));
		optionsBtn.onClick.add(() -> onSelectionClicked(optionsTileScrollBG, new OptionsSubState(() -> onSelectionExited(optionsTileScrollBG))));
		creditsBtn.onClick.add(() -> onSelectionClicked(creditsTileScrollBG, new CreditsSubState(() -> onSelectionExited(creditsTileScrollBG))));

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

		switch (targetState?.toLowerCase())
		{
			case 'storymenu':
				TSFunc = () -> storymenuBtn.onClick.dispatch();
			case 'credits':
				TSFunc = () -> creditsBtn.onClick.dispatch();
			case 'optionsmenu':
				TSFunc = () -> optionsBtn.onClick.dispatch();
			case 'debugmenu':
				TSFunc = debugSubState;
		}

		if (TSFunc != null)
		{
			FlxG.mouse.visible = false;

			for (obj in [storymenuBtn, optionsBtn, creditsBtn, logo, titleTileScrollBG,])
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

		bgScrolling = titleTileScrollBG.debugModeInUse;
		if (bgScrolling)
		{
			blurFilterBG.blurX = FlxMath.lerp(blurFilterBG.blurX, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);
			blurFilterBG.blurY = FlxMath.lerp(blurFilterBG.blurY, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);

			blurFilterFG.blurX = FlxMath.lerp(blurFilterFG.blurX, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);
			blurFilterFG.blurY = FlxMath.lerp(blurFilterFG.blurY, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);
			blurCamFG.alpha = FlxMath.lerp(blurCamFG.alpha, 0.15, Constants.DEFAULT_LERP_SPEED);
		}
		else
		{
			blurFilterBG.blurX = FlxMath.lerp(blurFilterBG.blurX, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);
			blurFilterBG.blurY = FlxMath.lerp(blurFilterBG.blurY, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_LERP_SPEED);

			blurFilterFG.blurX = FlxMath.lerp(blurFilterFG.blurX, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);
			blurFilterFG.blurY = FlxMath.lerp(blurFilterFG.blurY, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_LERP_SPEED);
			blurCamFG.alpha = FlxMath.lerp(blurCamFG.alpha, 1, Constants.DEFAULT_LERP_SPEED);

			nonScrollingControls();
		}

		if (controls.justPressed.TITLE_DEBUG && subState == null)
			debugSubState();
	}

	function debugSubState()
	{
		onSelectionClicked(debugTileScrollBG, new DebugSubState(() -> onSelectionExited(debugTileScrollBG)));
	}

	function nonScrollingControls()
	{
		if (controls.justPressed.TITLE_DEBUG_TRANSITION && subState == null)
			FlxG.switchState(() -> new TitleState());
	}

	var transitioning:Bool = false;

	function onSelectionClicked(tileScrollBG:TileScrollBG, substate:OSASubState)
	{
		if (transitioning)
			return;

		transitioning = true;

		for (spr in [logo, storymenuBtn, creditsBtn, optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 0}, this.transIn.duration, {ease: FlxEase.sineInOut});
		}

		if (tileScrollBG != null)
		{
			FlxTween.cancelTweensOf(tileScrollBG);
			FlxTween.tween(tileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		SoundUtil.selectSfx();

		openSubState(substate);
	}

	function onSelectionExited(tileScrollBG:TileScrollBG)
	{
		transitioning = false;

		for (spr in [logo, storymenuBtn, creditsBtn, optionsBtn])
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		if (titleTileScrollBG.alpha < 1)
		{
			FlxTween.cancelTweensOf(titleTileScrollBG);
			FlxTween.tween(titleTileScrollBG, {alpha: 1}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		FlxG.mouse.visible = true;

		if (tileScrollBG != null)
		{
			FlxTween.cancelTweensOf(tileScrollBG);
			FlxTween.tween(tileScrollBG, {alpha: 0}, this.transOut.duration, {ease: FlxEase.sineInOut});
		}

		SoundUtil.cancelSfx();
	}

	override function onExit()
	{
		super.onExit();

		bgScrolling = false;
	}
}
