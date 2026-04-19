package osa.objects.visualnovel.editors;

import flixel.addons.ui.FlxUIButton;
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
		var lines:Array<StrNameLabel> = [for (i => line in _tale?.lines ?? []) new StrNameLabel('Line #${i + 1}', '$i')];

		@:privateAccess
		var btnLines:Array<FlxUIButton> = [for (i => line in lines) linesDropdown.makeListButton(i, line.label, line.name)];

		var diffs = 0;

		for (i => line in linesDropdown.list)
		{
			if (btnLines[i].label.text != line.label.text)
			{
				diffs++;
			}
		}

		if (diffs > 0)
		{
			trace('Updated Lines Dropdown ($diffs diffs)');
			linesDropdown.list = btnLines;
		}
	}
}
