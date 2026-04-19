package osa.objects.visualnovel.editors;

import osa.data.visualnovel.tales.TaleLineData;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUIInputText;
import osa.data.visualnovel.SpeakerData;
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

	public var textInput:FlxUIInputText;

	override function create()
	{
		super.create();

		name = 'Lines';

		linesDropdown = new FlxUIDropDownMenu(10, 20, null);
		linesDropdown.callback = onChangedLine;

		speakersDropdown = new FlxUIDropDownMenu(linesDropdown.x + linesDropdown.width + 10, linesDropdown.y,
			[for (speakerID in SpeakerData.speakers) new StrNameLabel(speakerID, speakerID)]);

		textInput = new FlxUIInputText(speakersDropdown.x + speakersDropdown.width + 10, speakersDropdown.y, 275, '', 8);

		add(makeText(linesDropdown, 'Selected Line: '));
		add(linesDropdown);

		add(makeText(speakersDropdown, 'Line Speaker: '));
		add(speakersDropdown);

		add(makeText(textInput, 'Line Text: '));
		add(textInput);
	}

	public function onChangedLine(indexStr:String)
	{
		// trace('onChangedLine: $indexStr');

		var index:Int = Std.parseInt(indexStr);

		var line:TaleLineData = _tale.lines[index] ?? null;

		if (line == null)
		{
			trace('Null line');
			return;
		}

		speakersDropdown.selectedId = speakersDropdown.getBtnById(line.speaker?.id ?? '').name;
		textInput.text = line.text;
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

			onChangedLine('0');
		}
	}
}
