package osa.objects.visualnovel.editors;

import flixel.addons.ui.StrNameLabel;
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

		linesDropdown = new FlxUIDropDownMenu(10, 10, null);
		add(linesDropdown);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		updateList();
	}

	public function updateList()
	{
		var lines:Array<StrNameLabel> = [for (i => line in _tale?.lines ?? []) new StrNameLabel('Line #$i', 'Line #$i')];

		if (lines.length == 0)
			linesDropdown.setData(null);
		else
			linesDropdown.setData(lines);
	}
}
