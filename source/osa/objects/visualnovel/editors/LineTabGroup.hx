package osa.objects.visualnovel.editors;

import flixel.text.FlxText;
import haxe.io.Path;
import lime.utils.Assets;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.StrNameLabel;
import osa.data.visualnovel.TaleData;
import flixel.addons.ui.FlxUIDropDownMenu;

class LineTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var linesDropdown:FlxUIDropDownMenu;

	public var speakersDropdown:FlxUIDropDownMenu;

	override function create()
	{
		super.create();

		name = 'Lines';

		linesDropdown = new FlxUIDropDownMenu(10, 20, null);

		var speakers:Array<StrNameLabel> = [];

		final speakersDir = 'speakers/'.visualNovelAsset().getFilesInDirectory().filter(f -> return f.endsWith('data'.jsonFile()));

		for (file in speakersDir)
		{
			var sf = Path.withoutExtension(file).split('/');

			var speakerID = sf[sf.length - 2];

			speakers.push(new StrNameLabel(speakerID, speakerID));
		}

		speakersDropdown = new FlxUIDropDownMenu(linesDropdown.x + linesDropdown.width + 10, linesDropdown.y, speakers);
		
		add(makeText(linesDropdown, 'Line: '));
		add(linesDropdown);
		
		add(makeText(speakersDropdown, 'Speaker: '));
		add(speakersDropdown);
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
