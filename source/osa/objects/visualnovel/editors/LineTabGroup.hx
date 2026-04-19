package osa.objects.visualnovel.editors;

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

	public var speakersStateDropdown:FlxUIDropDownMenu;
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

		speakersDropdown = new FlxUIDropDownMenu(linesDropdown.x + linesDropdown.width + 10, linesDropdown.y,
			[for (speakerID in SpeakerData.speakers) new StrNameLabel(speakerID, speakerID)], onSpeakerChange);

		textInput = new FlxUIInputText(speakersDropdown.x + speakersDropdown.width + 10, speakersDropdown.y, 275, '', 8);
		textInput.callback = onTextChange;

		speakersStateDropdown = new FlxUIDropDownMenu(textInput.x, textInput.y + textInput.height + 20, null, onSpeakerStateChange);

		newLineBTN = new FlxButton(speakersStateDropdown.x + speakersStateDropdown.width + 10, speakersStateDropdown.y, 'New Line', onNewLine);

		removeLineBTN = new FlxButton(newLineBTN.x + newLineBTN.width + 10, newLineBTN.y, 'Remove Line', onRemoveLine);

		add(makeText(linesDropdown, 'Selected Line: '));
		add(linesDropdown);

		add(makeText(speakersDropdown, 'Line Speaker ID: '));
		add(speakersDropdown);

		add(makeText(textInput, 'Line Text: '));
		add(textInput);

		add(makeText(speakersStateDropdown, 'Line Speaker State: '));
		add(speakersStateDropdown);

		add(newLineBTN);
		add(removeLineBTN);

		onSpeakerChange(speakersDropdown.selectedLabel);
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

	public function onSpeakerStateChange(speakerState:String)
	{
		if (onSpeakerStateChangeCallback != null)
			onSpeakerStateChangeCallback(speakerState, Std.parseInt(linesDropdown.selectedId));
	}

	public function onSpeakerChange(speakerID:String)
	{
		// trace('new speaker: $speakerID');

		var speaker = new SpeakerData(speakerID, speakerID.speakerAsset('data'.jsonFile()));

		speakersStateDropdown.setData([for (state in speaker.states) new StrNameLabel(state.id, state.id)]);
		onSpeakerStateChange(speaker.states[0].id);

		if (onSpeakerChangeCallback != null)
			onSpeakerChangeCallback(speaker.id, Std.parseInt(linesDropdown.selectedId));
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

		speakersDropdown.selectedId = speakersDropdown.getBtnById(line?.speaker?.id ?? SpeakerData.speakers[0])?.name;
		textInput.text = line?.text ?? '';

		onTextChange(textInput.text, '');

		onSpeakerChange(speakersDropdown.selectedId);
		speakersStateDropdown.selectedId = speakersStateDropdown.getBtnById(line?.speaker?.state ?? speakersStateDropdown.selectedId)?.name;
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
