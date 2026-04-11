package osa;

import osa.util.debug.CrashHandler;
import osa.save.Save;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import osa.menus.TitleState;
import osa.visualnovel.VNState;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends OSAState
{
	override public function new()
	{
		FlxTransitionableState.defaultTransIn = OSAState.DEFAULT_TRANSITION;
		FlxTransitionableState.defaultTransOut = OSAState.DEFAULT_TRANSITION;

		final thisOutro = OSAState.DEFAULT_TRANSITION;
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
	}

	function leave()
	{
		throw 'Testing Crash';

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
		var msgs:Array<String> = 'splashTexts'.miscAsset().textSplit();

		if (msgs.length > 0)
		{
			final baseline:String = msgs[FlxG.random.int(0, msgs.length - 1)];

			trace(baseline);
			line = baseline.replace('--', '\n');
		}
		else
		{
			this.transOut.duration = this.transOut.duration / 4;
		}

		var clearWatermark:Array<String> = [
			'Hello.--Do you want to play with me?',
			'Here I come!',
			'April fools!--I rearranged your guts.',
			'Written before TADC Episode 9 : Alan we are so fucked.',
			'E-E-A-OO',
			'I know what you are.',
			'SO.--YOU COULDN\'T KEEP.--YOUR GOOFY,--LITTLE,--FUCKING MOUTH,--SHUT.',
			'Am I...------Getting through?',
			'She was 17 Scott.',
		];

		if (clearWatermark.contains(line.replace('\n', '--')))
			_watermark.text = line;
		else
			_watermark.text += '\n\n${line}';

		_watermark.screenCenter();

		leave();
	}
}
