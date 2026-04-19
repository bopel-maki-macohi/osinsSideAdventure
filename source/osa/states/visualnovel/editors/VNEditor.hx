package osa.states.visualnovel.editors;

import osa.data.visualnovel.TaleData;
import flixel.addons.ui.FlxUITabMenu;
import osa.states.menus.TitleState;
import flixel.FlxG;

class VNEditor extends OSAState
{
	public var uiBox:FlxUITabMenu;

	public var _tale:TaleData;

	override function create()
	{
		_tale = new TaleData(null);

		var tabs = [{name: 'Lines', label: 'Lines'}, {name: 'Storymenu', label: 'Storymenu'},];

		uiBox = new FlxUITabMenu(null, null, tabs, true);
		add(uiBox);

		uiBox.resize(640, 480);
		uiBox.setPosition(20, 20);
		uiBox.selected_tab = 0;

		uiBox.screenCenter(Y);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.justPressed.LEAVE)
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
	}
}
