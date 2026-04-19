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

		var speakers = [for (speakerID in SpeakerData.speakers) new StrNameLabel(speakerID, speakerID)];
		speakers.insert(0, new StrNameLabel('', ''));

		speakersDropdown = new FlxUIDropDownMenu(linesDropdown.x + linesDropdown.width + 10, linesDropdown.y, speakers, onSpeakerChange);
		speakersDropdown.selectedId = '';

		textInput = new FlxUIInputText(speakersDropdown.x + speakersDropdown.width + 10, speakersDropdown.y, 275, '', 8);
		textInput.callback = onTextChange;

		speakersStateDropdown = new FlxUIDropDownMenu(textInput.x, textInput.y + textInput.height + 20, null, onSpeakerStateChange);
		speakersStateDropdown.selectedId = '';

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
		// trace('new speaker state: "$speakerState"');

		if (onSpeakerStateChangeCallback != null)
			onSpeakerStateChangeCallback(speakerState, Std.parseInt(linesDropdown.selectedId));
	}

	public function onSpeakerChange(speakerID:String)
	{
		// trace('new speaker: "$speakerID"');

		var speaker:SpeakerData = null;

		if (speakerID.trim() == '')
			speaker = new SpeakerData(null, null);
		else
			speaker = new SpeakerData(speakerID, speakerID.speakerAsset('data'.jsonFile()));

		var newList = [for (state in speaker.states) new StrNameLabel(state.id, state.id)];

		if (newList.length == 0)
		{
			@:privateAccess
			var newBtnList = [
				for (i => state in newList)
					speakersStateDropdown.makeListButton(i, state.label, state.name)
			];
			DropdownListUpdater.updateList(newList, newBtnList, speakersStateDropdown, '');
			onSpeakerStateChange('');
		}
		else
		{
			speakersStateDropdown.setData(newList);
			onSpeakerStateChange(speaker?.states[0]?.id ?? newList[0].name);
		}

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

		speakersDropdown.selectedId = speakersDropdown.getBtnById(line?.speaker?.id ?? '')?.name;
		onSpeakerChange(speakersDropdown.selectedId);

		speakersStateDropdown.selectedId = speakersStateDropdown.getBtnById(line?.speaker?.state ?? '')?.name;
		onSpeakerStateChange(speakersStateDropdown.selectedId);

		textInput.text = line?.text ?? '';
		onTextChange(textInput.text, '');
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
