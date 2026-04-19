package osa.objects.visualnovel.editors;

import osa.data.visualnovel.TaleData;
import flixel.addons.ui.FlxUIDropDownMenu;

class LineTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var linesDropdown:FlxUIDropDownMenu;

	override function create()
	{
		super.create();

		name = 'Lines';

        linesDropdown = new FlxUIDropDownMenu(10, 10, []);
        add(linesDropdown);
	}
}
