package osa.states.visualnovel.editors;

import osa.states.menus.TitleState;
import flixel.FlxG;

class VNEditor extends OSAState
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.justPressed.LEAVE)
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
	}
}
