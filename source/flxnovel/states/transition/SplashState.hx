package flxnovel.states.transition;

import flxnovel.util.ISingletonAutomake;
import flixel.util.FlxColor;
import flxnovel.modding.scripting.ScriptHandler;
import flixel.text.FlxText;
import flxnovel.util.VersionUtil;
import flxnovel.states.menus.OutdatedState;
import flxnovel.util.Constants;
import flxnovel.states.menus.TitleState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flxnovel.util.macros.MacroUtil;
import flxnovel.save.Save;
import haxe.Json;
import flxnovel.data.SplashTextsData;
import flixel.FlxG;

class SplashState extends FlxNovelState implements ISingletonAutomake
{
	override public function new()
	{
		final thisOutro = FlxNovelState.DEFAULT_TRANSITION;
		thisOutro.duration = 8;

		super(FlxNovelState.DEFAULT_TRANSITION, thisOutro);
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

		initTextOBJ();
		initMsg();
		displayMsg();
	}

	var splashText:FlxText;

	function initTextOBJ()
	{
		splashText = new FlxText(10, 10, FlxG.width, 'O.S.A. ${VersionUtil.VERSION} (${Constants.GIT_STRING})', 16);
		splashText.alignment = LEFT;
		splashText.color = FlxColor.WHITE;
		splashText.y = FlxG.height - splashText.height;

		add(splashText);

		splashText.alignment = CENTER;
		splashText.size = 32;
		splashText.alpha = 0;

		splashText.text = FlxG.stage.window.title;

		splashText.text = '${FlxG.stage.application.meta.get('name')} ${FlxG.stage.application.meta.get('version')}';
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

	public var specialCase:Dynamic;

	function displayMsg()
	{
		if (msg != null && msg.clearWatermark)
			splashText.text = line;
		else
			splashText.text += '\n\n${line}';

		splashText.screenCenter();

		FlxTween.tween(splashText, {alpha: 1}, this.transIn.duration * 0.25);

		if (msg?.specialCase != null)
		{
			trace(msg.specialCase);
			specialCase = Reflect.field(this, msg.specialCase);

			ScriptHandler.call('splashSpecialCase', [specialCase, msg.specialCase]);

			trace(specialCase);
			if (specialCase != null)
			{
				FlxTimer.wait(this.transIn.duration * 2, specialCase);
				return;
			}
		}

		FlxTimer.wait(this.transIn.duration * 2, leave);
	}

	public function leave()
	{
		if (VersionUtil.OUTDATED && !OutdatedState.SEEN)
			FlxG.switchState(() -> new OutdatedState());
		else
			FlxG.switchState(() -> new TitleState());
	}

	public function piracy()
	{
		FlxG.sound.play('prowler'.miscAsset().audioFile(), 1.0, false, null, true, leave);
	}
}
