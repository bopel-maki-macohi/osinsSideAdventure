package osa;

import osa.util.Controls;
import osa.states.transition.SplashState;
import osa.objects.RhythmManager;
import osa.states.visualnovel.VNState;
import osa.util.macros.MacroUtil;
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

		InitState.IMPORTANT_INITALIZED = true;
	}

	function unimportantInit()
	{
		RhythmManager.instance = new RhythmManager();

		Controls.instance = new Controls('Main');

		OSACache.init();
	}

	function leave()
	{
		var ENTER_VN = MacroUtil.getDefine('ENTER_VN');

		if (ENTER_VN != null)
			FlxG.switchState(() -> VNState.build(ENTER_VN));
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
		else
			FlxG.switchState(() -> new SplashState());
	}
}
