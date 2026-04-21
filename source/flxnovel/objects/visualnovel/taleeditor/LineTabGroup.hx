package flxnovel.objects.visualnovel.taleeditor;

import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUINumericStepper;
import flxnovel.util.DropdownListUpdater;
import flxnovel.data.visualnovel.tales.ITaleContainer;
import flixel.ui.FlxButton;
import flxnovel.data.visualnovel.tales.TaleLineData;
import flixel.addons.ui.FlxUIInputText;
import flxnovel.data.visualnovel.SpeakerData;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.StrNameLabel;
import flxnovel.data.visualnovel.TaleData;
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

	public var autoSkipStepper:FlxUINumericStepper;
	public var onAutoSkipStepCallback:Float->Int->Void;

	override function create()
	{
		super.create();

		name = 'Lines';

		linesDropdown = new FlxUIDropDownMenu(10, 20, null, onChangedLine);
		linesDropdown.name = 'Lines';

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

		autoSkipStepper = new FlxUINumericStepper(removeLineBTN.x + removeLineBTN.width + 10, removeLineBTN.y + 5, 0.1, 0, 0.0, 60.0, 1);
		autoSkipStepper.value = 0;
		autoSkipStepper.name = 'line_autoSkip';

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

		add(makeText(autoSkipStepper, 'Auto Skip Time (Seconds): '));
		add(autoSkipStepper);

		onSpeakerChange(speakersDropdown.selectedLabel);
	}

	// small yoink from FNF legacy code
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		var index:Int = Std.parseInt(linesDropdown.selectedId) ?? 0;

		trace({
			id: id,
			sender: sender,
			data: data,
			params: params,
		});

		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;

			switch (label) {}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;

			if (wname == 'line_autoSkip' && onAutoSkipStepCallback != null)
				onAutoSkipStepCallback(nums.value, index);
		}
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
		onChangedLineBasic(indexStr);

		onChangedLineCallback();
	}

	public function onChangedLineBasic(indexStr:String)
	{
		var line:TaleLineData = _tale?.lines[Std.parseInt(indexStr)] ?? null;

		speakersDropdown.selectedId = line?.speaker?.id ?? '';
		textInput.text = line?.text ?? '';
		speakersStateInput.text = line?.speaker?.state ?? '';
		autoSkipStepper.value = line?.autoSkip ?? 0.0;
	}

	public function onChangedLineCallback()
	{
		onSpeakerChange(speakersDropdown.selectedId);
		onTextChange(textInput.text, '');
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
