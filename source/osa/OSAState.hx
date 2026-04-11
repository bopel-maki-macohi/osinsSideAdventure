package osa;

import flixel.math.FlxPoint;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIState;

class OSAState extends FlxUIState
{
	public static var DEFAULT_TRANSITION(get, never):TransitionData;

	static function get_DEFAULT_TRANSITION():TransitionData
	{
		var transGraphic = FlxGraphic.fromClass(cast GraphicTransTileDiamond);
		transGraphic.persist = true;
		transGraphic.destroyOnNoUse = false;

		return new TransitionData(TILES, FlxColor.WHITE, .5, FlxPoint.get(0, -1), {
			asset: transGraphic,
			width: 32,
			height: 32
		},);
	}

	public var _watermark:FlxText;

	override function create()
	{
		super.create();

		_watermark = new FlxText(10, 10, FlxG.width, 'O.S.A. ${FlxG.stage.application.meta.get('version')}', 16);
		_watermark.alignment = LEFT;
		_watermark.color = FlxColor.WHITE;

		#if debug
		add(_watermark);
		#end
	}
}
