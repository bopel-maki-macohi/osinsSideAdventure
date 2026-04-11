package osa;

import osa.menus.TitleState;
import osa.visualnovel.VNState;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.switchState(() -> new TitleState());
	}
}
