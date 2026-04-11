package osa;

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
		var transGraphic = FlxGraphic.fromClass(cast GraphicTransTileDiamond);
		transGraphic.persist = true;
		transGraphic.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.WHITE, .5, FlxPoint.get(0, -1), {
			asset: transGraphic,
			width: 32,
			height: 32
		},);
		FlxTransitionableState.defaultTransOut = FlxTransitionableState.defaultTransIn;

		super();

		this.transIn.duration = 1;
		this.transOut.duration = 1;
	}

	override public function create()
	{
		super.create();

		#if !debug
		add(_watermark);
		#end
		_watermark.alignment = CENTER;
		_watermark.size = 32;

		_watermark.text = _watermark.text.replace('O.S.A.', 'Osin\'s Side Adventure');
		FlxG.stage.application.window.title = _watermark.text;

		var line:String = 'Have fun!';
		var msgs:Array<String> = 'initStateMSGS'.miscAsset().textSplit();

		if (msgs.length > 0)
		{
			line = msgs[FlxG.random.int(0, msgs.length - 1)].replace('--', '\n');
			trace(line);
		}

		_watermark.text += '\n\n${line}';

		_watermark.screenCenter();

		FlxG.switchState(() -> new TitleState());
	}
}
