package osa.states.transition;

import osa.states.menus.OutdatedState;
import osa.util.Constants;
import osa.states.menus.TitleState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import osa.util.macros.MacroUtil;
import osa.save.Save;
import haxe.Json;
import osa.data.SplashTextsData;
import flixel.FlxG;

class SplashState extends OSAState
{
	override public function new()
	{
		final thisOutro = OSAState.DEFAULT_TRANSITION;
		if (!MacroUtil.isDefined('SKIP_SPLASH'))
			thisOutro.duration = 8;

		super(OSAState.DEFAULT_TRANSITION, thisOutro);
	}

	var line:String = null;

	var msgs:SplashTextsData = null;
	var debugMsgs:Array<SplashTextData> = [];

	var msg:SplashTextData = null;

	override function create()
	{
		super.create();

		line = 'Have fun!';

		msgs = Json.parse('splashTexts'.miscAsset().jsonFile().readText());
		debugMsgs = msgs.lines.filter(l -> return l?.filter == 'debug');

		initWatermark();
		initMsg();
		displayMsg();
	}

	function initWatermark()
	{
		#if !debug
		add(_watermark);
		#end

		_watermark.alignment = CENTER;
		_watermark.size = 32;
		_watermark.alpha = 0;

		_watermark.text = FlxG.stage.window.title;

		_watermark.text.replace(' (${Constants.GIT_STRING})', '');
	}

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

	function initMsg()
	{
		if (msgs.lines.length > 0)
		{
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
			this.transOut.duration = this.transIn.duration;

		line = line.replace('%user%', MacroUtil.getUSR());

		trace(line.replace('\n', '--'));
	}

	function displayMsg()
	{
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

	function leave()
	{
		if (Constants.OUTDATED && !OutdatedState.SEEN)
			FlxG.switchState(() -> new OutdatedState());
		else
			FlxG.switchState(() -> new TitleState());
	}

	function piracy()
	{
		FlxG.sound.play('prowler'.miscAsset().audioFile(), 1.0, false, null, true, leave);
	}
}
