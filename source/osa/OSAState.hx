package osa;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIState;

class OSAState extends FlxUIState
{
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
