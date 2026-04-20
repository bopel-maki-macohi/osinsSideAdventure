package flxnovel;

import flxnovel.modding.ModCore;
import flxnovel.states.visualnovel.editors.*;
import flxnovel.states.visualnovel.VNState;
import flxnovel.util.*;
import flxnovel.states.transition.SplashState;
import flxnovel.objects.RhythmManager;
import flxnovel.util.macros.*;
import flxnovel.util.debug.CrashHandler;
import flxnovel.save.Save;
import flixel.addons.transition.FlxTransitionableState;
import flxnovel.states.menus.TitleState;
import flixel.FlxG;
import flxnovel.util.plugins.ScreenshotPlugin;
import flxnovel.states.FlxNovelState;
import flxnovel.states.debug.*;

class InitState extends FlxNovelState
{
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

	function importantInit()
	{
		CrashHandler.init();

		Save.init();

		ScreenshotPlugin.init();

		ScriptUtil.init();
		
		FlxG.signals.postUpdate.add(modReloadCheck);

		FlxG.console.registerClass(Constants);
		FlxG.console.registerClass(MacroUtil);
		FlxG.console.registerClass(OutdatedUtil);

		InitState.IMPORTANT_INITALIZED = true;
	}

	function modReloadCheck()
	{
		if (controls.justPressed.MOD_RELOAD)
		{
			ModCore.reload();
			FlxG.resetState();
		}
	}

	function unimportantInit()
	{
		RhythmManager.instance = new RhythmManager();

		Controls.instance = new Controls('Main');

		ModCore.reload();
		
		#if DISABLE_OUTDATEDSTATE
		flxnovel.states.menus.OutdatedState.SEEN = true;
		#end

		#if web
		// pixel perfect render fix!
		FlxG.stage.application.window.element.style.setProperty("image-rendering", "pixelated");
		#end
	}

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
