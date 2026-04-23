package flxnovel;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flxnovel.util.plugins.*;
import flxnovel.modding.ModCore;
import flxnovel.states.visualnovel.editors.*;
import flxnovel.states.visualnovel.VNState;
import flxnovel.util.*;
import flxnovel.states.transition.SplashState;
import flxnovel.util.macros.*;
import flxnovel.util.debug.CrashHandler;
import flxnovel.save.Save;
import flxnovel.states.menus.title.*;
import flxnovel.states.FlxNovelState;
import flxnovel.states.debug.*;

class InitState extends FlxNovelState
{
	/**
	 * This is to make sure
	 * important initalization steps
	 * are not repeated.
	 */
	public static var IMPORTANT_INITALIZED:Bool = false;

	override public function new()
	{
		FlxTransitionableState.defaultTransIn = FlxNovelState.DEFAULT_TRANSITION;
		FlxTransitionableState.defaultTransOut = FlxNovelState.DEFAULT_TRANSITION;

		super(null, null);
	}

	override public function create()
	{
		if (!InitState.IMPORTANT_INITALIZED)
			importantInit();
		unimportantInit();

		this.transIn = null;

		super.create();

		leave();
	}

	/**
	 * Initialize important things only once.
	 * 
	 * Examples include the Crash Handler and Save Class
	 */
	function importantInit()
	{
		CrashHandler.init();

		Save.init();

		ScriptUtil.init();

		ScreenshotPlugin.init();
		VolumeManagerPlugin.init();

		FlxG.signals.postUpdate.add(modReloadCheck);

		FlxG.console.registerClass(Constants);
		FlxG.console.registerClass(MacroUtil);
		FlxG.console.registerClass(OutdatedUtil);

		InitState.IMPORTANT_INITALIZED = true;
	}

	/**
	 * Watch out for the mod reloading keybind,
	 * if it's just pressed then `ModCore` will reload and the state will be reset
	 */
	function modReloadCheck()
	{
		if (controls.justPressed.MOD_RELOAD)
		{
			ModCore.reload();
			FlxG.resetState();
		}
	}

	/**
	 * It doens't matter if these are initalized
	 * multiple times. It'll be fine.
	 */
	function unimportantInit()
	{
		ModCore.reload();

		#if DISABLE_OUTDATEDSTATE
		flxnovel.states.menus.OutdatedState.SEEN = true;
		#end

		#if web
		// pixel perfect render fix!
		FlxG.stage.application.window.element.style.setProperty("image-rendering", "pixelated");
		#end
	}

	/**
	 * Moving on to the next state,
	 * alot of this is checking for defines.
	 */
	function leave()
	{
		var ENTER_VN = MacroUtil.getDefine('ENTER_VN');

		if (ENTER_VN != null)
			FlxG.switchState(() -> new VNState(ENTER_VN));
		else if (MacroUtil.isDefined('TALESMENU'))
			FlxG.switchState(() -> new TitleState('TALESMENU'));
		else if (MacroUtil.isDefined('CREDITS'))
			FlxG.switchState(() -> new TitleState('CREDITS'));
		else if (MacroUtil.isDefined('OPTIONSMENU'))
			FlxG.switchState(() -> new TitleState('OPTIONSMENU'));
		else if (MacroUtil.isDefined('DEBUGMENU'))
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		else if (MacroUtil.isDefined('MODS'))
			FlxG.switchState(() -> new TitleState('MODS'));
		else if (MacroUtil.isDefined('TITLE') || MacroUtil.isDefined('SKIP_SPLASH'))
			FlxG.switchState(() -> new TitleState());
		else if (MacroUtil.isDefined('VIDEODEBUG'))
			FlxG.switchState(() -> new TestVideoState());
		else if (MacroUtil.isDefined('TALEEDITOR'))
			FlxG.switchState(() -> new TaleEditor());
		else if (MacroUtil.isDefined('SPEAKEREDITOR'))
			FlxG.switchState(() -> new SpeakerEditor());
		else if (MacroUtil.isDefined('BGDEBUG'))
			FlxG.switchState(() -> new BackgroundTesting());
		else
			FlxG.switchState(() -> new SplashState());
	}
}
