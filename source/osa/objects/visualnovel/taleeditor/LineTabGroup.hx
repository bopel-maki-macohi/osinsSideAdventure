package osa.objects.visualnovel.taleeditor;

import flixel.ui.FlxButton;
import osa.data.visualnovel.tales.TaleLineData;
import flixel.addons.ui.FlxUIInputText;
import osa.data.visualnovel.SpeakerData;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.StrNameLabel;
import osa.data.visualnovel.TaleData;
import flixel.addons.ui.FlxUIDropDownMenu;

class LineTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var linesDropdown:FlxUIDropDownMenu;

	public var speakersDropdown:FlxUIDropDownMenu;
	public var onSpeakerChangeCallback:String->Int->Void;

	public var speakersStateInput:FlxUIInputText;
	public var onSpeakerStateChangeCallback:String->Int->Void;

	public var textInput:FlxUIInputText;
	public var onTextChangeCallback:String->Int->Void;

	public var newLineBTN:FlxButton;
	public var onNewLineCallback:Void->Void;

	public var removeLineBTN:FlxButton;
	public var onRemoveLineCallback:Int->Void;

	override function create()
	{
		super.create();

		name = 'Lines';

		linesDropdown = new FlxUIDropDownMenu(10, 20, null, onChangedLine);

		var speakers = [for (speakerID in SpeakerData.speakers) new StrNameLabel(speakerID, speakerID)];
		speakers.insert(0, new StrNameLabel('', ''));

		speakersDropdown = new FlxUIDropDownMenu(linesDropdown.x + linesDropdown.width + 10, linesDropdown.y, speakers, onSpeakerChange);
		speakersDropdown.selectedId = '';

		textInput = new FlxUIInputText(speakersDropdown.x + speakersDropdown.width + 10, speakersDropdown.y, 320, '', 8);
		textInput.callback = onTextChange;

		speakersStateInput = new FlxUIInputText(textInput.x, textInput.y + textInput.height + 20, Math.round(textInput.width), '', textInput.size);
		speakersStateInput.callback = onSpeakerStateChange;

		newLineBTN = new FlxButton(speakersStateInput.x, speakersStateInput.y + speakersStateInput.height + 10, 'New Line', onNewLine);

		removeLineBTN = new FlxButton(newLineBTN.x + newLineBTN.width + 10, newLineBTN.y, 'Remove Line', onRemoveLine);

		add(makeText(linesDropdown, 'Selected Line: '));
		add(linesDropdown);

		add(makeText(speakersDropdown, 'Line Speaker ID: '));
		add(speakersDropdown);

		add(makeText(textInput, 'Line Text: '));
		add(textInput);

		add(makeText(speakersStateInput, 'Line Speaker State: '));
		add(speakersStateInput);

		add(newLineBTN);
		add(removeLineBTN);

		onSpeakerChange(speakersDropdown.selectedLabel);
	}

	public function onSpeakerStateChange(text:String, action:String)
	{
		if (onSpeakerStateChangeCallback != null)
			onSpeakerStateChangeCallback(text, Std.parseInt(linesDropdown.selectedId));
	}

	public function onRemoveLine()
	{
		if (onRemoveLineCallback != null)
			onRemoveLineCallback(Std.parseInt(linesDropdown.selectedId));
	}

	public function onNewLine()
	{
		if (onNewLineCallback != null)
			onNewLineCallback();
	}

	public function onSpeakerChange(speakerID:String)
	{
		// trace('new speaker: "$speakerID"');

		var speaker:SpeakerData = null;

		if (speakerID.trim() == '')
			speaker = new SpeakerData(null, null);
		else
			speaker = new SpeakerData(speakerID, speakerID.speakerAsset('data'.jsonFile()));

		if (onSpeakerChangeCallback != null)
			onSpeakerChangeCallback(speakerID, Std.parseInt(linesDropdown.selectedId));
	}

	public function onTextChange(text:String, action:String)
	{
		if (onTextChangeCallback != null)
			onTextChangeCallback(text, Std.parseInt(linesDropdown.selectedId));
	}

	public function onChangedLine(indexStr:String)
	{
		var index:Int = Std.parseInt(indexStr);

		var line:TaleLineData = _tale?.lines[index] ?? null;

		speakersDropdown.selectedId = line?.speaker?.id ?? '';
		onSpeakerChange(speakersDropdown.selectedId);

		textInput.text = line?.text ?? '';
		onTextChange(textInput.text, '');

		speakersStateInput.text = line?.speaker?.state ?? '';
		onSpeakerStateChange(speakersStateInput.text, '');
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
		DropdownListUpdater.updateList(lines, btnLines, linesDropdown, '0', () -> onChangedLine('0'));
	}
}
