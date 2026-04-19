package osa;

import osa.modding.ModCore;
import osa.states.visualnovel.editors.TaleEditor;
import osa.states.visualnovel.VNState;
import osa.states.debug.TestVideoState;
import osa.util.*;
import osa.states.transition.SplashState;
import osa.objects.RhythmManager;
import osa.util.macros.*;
import osa.util.debug.CrashHandler;
import osa.save.Save;
import flixel.addons.transition.FlxTransitionableState;
import osa.states.menus.TitleState;
import flixel.FlxG;
import osa.util.plugins.ScreenshotPlugin;
import osa.states.OSAState;

class InitState extends OSAState
{
	public static var IMPORTANT_INITALIZED:Bool = false;

	override public function new()
	{
		FlxTransitionableState.defaultTransIn = OSAState.DEFAULT_TRANSITION;
		FlxTransitionableState.defaultTransOut = OSAState.DEFAULT_TRANSITION;

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
		osa.states.menus.OutdatedState.SEEN = true;
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
		else if (MacroUtil.isDefined('STORYMENU'))
			FlxG.switchState(() -> new TitleState('STORYMENU'));
		else if (MacroUtil.isDefined('CREDITS'))
			FlxG.switchState(() -> new TitleState('CREDITS'));
		else if (MacroUtil.isDefined('OPTIONSMENU'))
			FlxG.switchState(() -> new TitleState('OPTIONSMENU'));
		else if (MacroUtil.isDefined('DEBUGMENU'))
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		else if (MacroUtil.isDefined('TITLE'))
			FlxG.switchState(() -> new TitleState());
		else if (MacroUtil.isDefined('VIDEODEBUG'))
			FlxG.switchState(() -> new TestVideoState());
		else if (MacroUtil.isDefined('VNEDITOR') || MacroUtil.isDefined('TALEEDITOR'))
			FlxG.switchState(() -> new TaleEditor());
		else
			FlxG.switchState(() -> new SplashState());
	}
}
