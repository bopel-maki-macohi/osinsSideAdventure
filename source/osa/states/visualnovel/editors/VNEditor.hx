package osa.states.visualnovel.editors;

import osa.objects.visualnovel.editors.TabMenu;
import osa.data.visualnovel.TaleData;
import osa.states.menus.TitleState;
import flixel.FlxG;

class VNEditor extends OSAState
{
	public var _tale:TaleData;

	public var uiBox:TabMenu;

	override function create()
	{
		_tale = new TaleData(null);

		add(uiBox = new TabMenu());

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.justPressed.LEAVE)
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
	}
}
