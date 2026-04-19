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

	public var lines(get, never):Array<StrNameLabel>;

	function get_lines():Array<StrNameLabel>
	{
		return [for (i => line in _tale?.lines ?? []) new StrNameLabel('$i', 'Line #${i + 1}')];
	}

	public var btnLines(get, never):Array<FlxUIButton>;

	function get_btnLines():Array<FlxUIButton>
	{
		@:privateAccess
		return [for (i => line in lines) linesDropdown.makeListButton(i, line.label, line.name)];
	}

	public function updateList()
	{
		var diffs = 0;

		if (linesDropdown.list.length < btnLines.length || linesDropdown.list.length > btnLines.length)
			diffs += btnLines.length - linesDropdown.list.length;

		for (i => line in linesDropdown.list)
		{
			if (line?.label?.text != btnLines[i]?.label?.text)
				diffs++;
		}

		if (diffs > 0)
		{
			trace('Updated Lines Dropdown ($diffs diffs)');
			linesDropdown.setData(lines);
		}
	}
}
