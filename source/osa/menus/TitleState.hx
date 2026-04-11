package osa.menus;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import osa.objects.TileScrollBG;
import flixel.FlxState;

class TitleState extends FlxState
{
	public var _tileScrollBG:TileScrollBG;

	public var _logo:FlxSprite;

	override function create()
	{
		super.create();

		_tileScrollBG = new TileScrollBG(FlxPoint.get(64, 64), true);

		_logo = new FlxSprite(0, 0, 'logo'.imageFile().menuAsset());
        _logo.screenCenter();

		add(_tileScrollBG);
		add(_logo);
	}
}
