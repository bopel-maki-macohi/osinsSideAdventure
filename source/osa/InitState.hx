package osa;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import osa.data.SplashTextsData;
import haxe.Json;
import osa.objects.RhythmManager;
import osa.states.visualnovel.VNState;
import osa.util.MacroUtil;
import osa.util.debug.CrashHandler;
import osa.save.Save;
import flixel.addons.transition.FlxTransitionableState;
import osa.states.menus.TitleState;
import flixel.FlxG;
import osa.util.plugins.ScreenshotPlugin;

class InitState extends OSAState
{
	public static var INITALIZED:Bool = false;

	override public function new()
	{
		FlxTransitionableState.defaultTransIn = OSAState.DEFAULT_TRANSITION;
		FlxTransitionableState.defaultTransOut = OSAState.DEFAULT_TRANSITION;

		final thisOutro = OSAState.DEFAULT_TRANSITION;
		if (!MacroUtil.isDefined('SKIP_SPLASH'))
			thisOutro.duration = 8;

		super(OSAState.DEFAULT_TRANSITION, thisOutro);
	}

	override public function create()
	{
		if (!InitState.INITALIZED)
			actualInit();

		super.create();

		FlxG.mouse.visible = false;

		splashWatermark();
	}

	function actualInit()
	{
		CrashHandler.init();

		Save.init();

		ScreenshotPlugin.init();

		RhythmManager.instance = new RhythmManager();

		InitState.INITALIZED = true;

		OSACache.performCaches();
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
		_watermark.alpha = 0;

		_watermark.text = _watermark.text.replace('O.S.A.', 'Osin\'s Side Adventure');
		FlxG.stage.application.window.title = _watermark.text;

		var line:String = 'Have fun!';

		var msgs:SplashTextsData = Json.parse('splashTexts'.miscAsset().jsonFile().readText());
		var debugMsgs:Array<SplashTextData> = msgs.lines.filter(l -> return l?.filter == 'debug');

		var msg:SplashTextData = null;

		if (msgs.lines.length > 0)
		{
			function randomMsg()
			{
				var target:SplashTextData = null;

				if (debugMsgs.length > 0 && #if debug true #else false #end)
					target = debugMsgs[FlxG.random.int(0, debugMsgs.length - 1)];
				else
					target = msgs.lines[FlxG.random.int(0, msgs.lines.length - 1)];

				function filterOut()
				{
					trace('Filtered out ${target.line} because of ${target.filter}');
				}

				switch (target?.filter?.toLowerCase())
				{
					case 'pcname':
						if (!Save.options.get().pcname)
							return filterOut();

					case 'debug':
						#if !debug
						return filterOut();
						#end
				}

				msg = target;
			}

			var i = 0;

			while (msg == null && i < 10)
			{
				randomMsg();
				i++;
			}

			if (msg != null)
				line = msg.line.join('\n');
		}
		else
		{
			this.transOut.duration = this.transIn.duration;
		}

		line = line.replace('%user%', MacroUtil.getUSR());

		trace(line.replace('\n', '--'));

		if (msg != null && msg.clearWatermark)
			_watermark.text = line;
		else
			_watermark.text += '\n\n${line}';

		_watermark.screenCenter();

		FlxTween.tween(_watermark, {alpha: 1}, this.transIn.duration * 0.25);

		if (msg?.specialCase != null)
		{
			trace(msg.specialCase);
			var specialCase:Dynamic = Reflect.field(this, msg.specialCase);

			if (specialCase != null)
			{
				FlxTimer.wait(this.transIn.duration * 2, specialCase);
				return;
			}
		}

		FlxTimer.wait(this.transIn.duration * 2, leave);
	}

	function piracy()
	{
		FlxG.sound.play('prowler'.miscAsset().audioFile(), 1.0, false, null, true, leave);
	}
}
