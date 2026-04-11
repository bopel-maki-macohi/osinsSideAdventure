package osa.menus;

import flixel.math.FlxPoint;
import osa.objects.TileScrollBG;
import flixel.FlxState;

class TitleState extends FlxState
{
    public var _tileScrollBG:TileScrollBG;

	override function create()
	{
		super.create();

        _tileScrollBG = new TileScrollBG(FlxPoint.get(64, 64));
        
        add(_tileScrollBG);
	}
}
