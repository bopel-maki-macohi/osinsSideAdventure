package osa;

import osa.data.SplashTextsData;
import haxe.Json;
import osa.objects.RhythmManager;
import osa.menus.storymenu.StoryMenuState;
import osa.visualnovel.VNState;
import osa.util.MacroUtil;
import osa.util.debug.CrashHandler;
import osa.save.Save;
import flixel.addons.transition.FlxTransitionableState;
import osa.menus.TitleState;
import flixel.FlxG;
import osa.util.plugins.ScreenshotPlugin;

class InitState extends OSAState
{
	override public function new()
	{
		FlxTransitionableState.defaultTransIn = OSAState.DEFAULT_TRANSITION;
		FlxTransitionableState.defaultTransOut = OSAState.DEFAULT_TRANSITION;

		final thisOutro = OSAState.DEFAULT_TRANSITION;
		if (!MacroUtil.isDefined('SKIP_SPLASH'))
			thisOutro.duration = 8;

		super(null, thisOutro);
	}

	override public function create()
	{
		super.create();

		actualInit();

		splashWatermark();
	}

	function actualInit()
	{
		Save.init();

		CrashHandler.init();

		ScreenshotPlugin.init();

		RhythmManager.instance = new RhythmManager();
	}

	function leave()
	{
		var ENTER_VN = MacroUtil.getDefine('ENTER_VN');

		if (ENTER_VN != null)
			FlxG.switchState(() -> new VNState(ENTER_VN));
		else if (MacroUtil.isDefined('STORYMENU'))
			FlxG.switchState(() -> new StoryMenuState());
		else
			FlxG.switchState(() -> new TitleState());
	}

	function splashWatermark()
	{
		#if !debug
		add(_watermark);
		#end
		_watermark.alignment = CENTER;
		_watermark.size = 32;

		_watermark.text = _watermark.text.replace('O.S.A.', 'Osin\'s Side Adventure');
		FlxG.stage.application.window.title = _watermark.text;

		var line:String = 'Have fun!';

		var msgs:SplashTextsData = Json.parse('splashTexts'.miscAsset().jsonFile().readText());
		var msg:SplashTextData = null;

		if (msgs.lines.length > 0)
		{
			function randomMsg()
			{
				var target = msgs.lines[FlxG.random.int(0, msgs.lines.length - 1)];

				switch (target.filter)
				{
					case 'pcname':
						if (!Save.options.get().pcname)
							return;
				}

				msg = target;
			}

			var i = 0;

			while (msg == null && i < 10)
			{
				randomMsg();
				i++;
			}

			line = msg.line.join('\n');
		}
		else
		{
			this.transOut.duration = this.transIn.duration;
		}

		if (msg != null && msg.clearWatermark)
			_watermark.text = line;
		else
			_watermark.text += '\n\n${line}';

		_watermark.screenCenter();

		leave();
	}
}
