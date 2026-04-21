package flxnovel.states.menus;

import flxnovel.util.ArrayUtil;
import flxnovel.util.SoundUtil;
import flxnovel.shaders.GrayscaleShader;
import flixel.util.FlxTimer;
import flxnovel.util.Constants;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flxnovel.objects.ClickableSprite;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import openfl.filters.BlurFilter;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flxnovel.objects.TileScrollBG;

class TitleState extends FlxNovelState
{
	public var titleTileScrollBG:TileScrollBG;

	public var talesTileScrollBG:TileScrollBG;
	public var debugTileScrollBG:TileScrollBG;
	public var modsTileScrollBG:TileScrollBG;
	public var creditsTileScrollBG:TileScrollBG;
	public var optionsTileScrollBG:TileScrollBG;

	public var logo:FlxSprite;

	public var blurFilterBG:BlurFilter;
	public var blurFilterFG:BlurFilter;

	public static var blurCamBG:FlxCamera;
	public static var blurCamFG:FlxCamera;

	public var talesBtn:ClickableSprite;
	public var optionsBtn:ClickableSprite;
	public var creditsBtn:ClickableSprite;
	public var modsBtn:ClickableSprite;

	public static var bgScrolling:Bool = false;

	public var targetState:String = null;

	override public function new(?targetState:String)
	{
		super();

		this.targetState = targetState;
	}

	public var btns(get, never):Array<ClickableSprite>;

	function get_btns():Array<ClickableSprite>
	{
		return [talesBtn, creditsBtn, optionsBtn, modsBtn];
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

		debugTileScrollBG = TileScrollBG.build(null, 'tiles/tile-debug'.menuAsset(), titleTileScrollBG);
		debugTileScrollBG.alpha = 0;

		talesTileScrollBG = TileScrollBG.build(null, 'tiles/tile-tales'.menuAsset(), titleTileScrollBG);
		talesTileScrollBG.alpha = 0;

		creditsTileScrollBG = TileScrollBG.build(null, 'tiles/tile-credits'.menuAsset(), titleTileScrollBG);
		creditsTileScrollBG.alpha = 0;

		optionsTileScrollBG = TileScrollBG.build(null, 'tiles/tile-options'.menuAsset(), titleTileScrollBG);
		optionsTileScrollBG.alpha = 0;

		modsTileScrollBG = TileScrollBG.build(null, 'tiles/tile-mods'.menuAsset(), titleTileScrollBG);
		modsTileScrollBG.alpha = 0;

		add(debugTileScrollBG);
		add(modsTileScrollBG);
		add(talesTileScrollBG);
		add(creditsTileScrollBG);
		add(optionsTileScrollBG);

		add(logo);

		talesBtn = new ClickableSprite(0, 0, 'title/tales'.menuAsset().imageFile());
		optionsBtn = new ClickableSprite(0, 0, 'title/options'.menuAsset().imageFile());
		creditsBtn = new ClickableSprite(0, 0, 'title/credits'.menuAsset().imageFile());
		modsBtn = new ClickableSprite(0, 0, 'title/mods'.menuAsset().imageFile());

		#if html5
		modsBtn.shader = new GrayscaleShader(.75);
		#end

		for (i => btn in btns)
		{
			btn.scale.set(0.5, 0.5);
			btn.updateHitbox();

			btn.ID = i;

			btn.cameras = [blurCamFG];

			btn.overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(btn, 0.6, 0.5));
			btn.unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(btn, 0.5, 0.5));

			add(btn);
		}

		talesBtn.onClick.add(() -> onSelectionClicked(talesTileScrollBG, new TalesSubState(() -> onSelectionExited(talesTileScrollBG))));
		optionsBtn.onClick.add(() -> onSelectionClicked(optionsTileScrollBG, new OptionsSubState(() -> onSelectionExited(optionsTileScrollBG))));
		creditsBtn.onClick.add(() -> onSelectionClicked(creditsTileScrollBG, new CreditsSubState(() -> onSelectionExited(creditsTileScrollBG))));
		#if !html5
		modsBtn.onClick.add(() -> onSelectionClicked(modsTileScrollBG, new ModsSubState(() -> onSelectionExited(modsTileScrollBG))));
		#end

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
			case 'talesmenu':
				TSFunc = () -> talesBtn.onClick.dispatch();
			case 'credits':
				TSFunc = () -> creditsBtn.onClick.dispatch();
			case 'optionsmenu':
				TSFunc = () -> optionsBtn.onClick.dispatch();
			case 'mods':
				TSFunc = () -> modsBtn.onClick.dispatch();
			case 'debugmenu':
				TSFunc = debugSubState;
		}

		if (TSFunc != null)
		{
			FlxG.mouse.visible = false;

			for (obj in ArrayUtil.merge([logo, titleTileScrollBG], btns))
			{
				var spr:FlxSprite = cast obj;

				if (spr != null)
					spr.alpha = 0;
			}

			FlxTimer.wait(transIn.duration, () ->
			{
				TSFunc();
			});
		}
	}

	public var paddingStart:Float = 0.3;
	public var paddingInc:Float = 1.3;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (i => btn in btns)
		{
			btn.y = FlxG.height - btn.height - (128 / 4);
			btn.x = (128 * paddingStart) + ((256 * i) * paddingInc);
		}

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

	function onSelectionClicked(tileScrollBG:TileScrollBG, substate:FlxNovelSubState)
	{
		if (transitioning)
			return;

		transitioning = true;

		for (obj in ArrayUtil.merge([logo], btns))
		{
			var spr:FlxSprite = cast obj;

			if (spr != null)
			{
				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {alpha: 0}, this.transIn.duration, {ease: FlxEase.sineInOut});
			}
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

		for (obj in ArrayUtil.merge([logo], btns))
		{
			var spr:FlxSprite = cast obj;

			if (spr != null)
			{
				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {alpha: 1}, this.transIn.duration, {ease: FlxEase.sineInOut});
			}
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
