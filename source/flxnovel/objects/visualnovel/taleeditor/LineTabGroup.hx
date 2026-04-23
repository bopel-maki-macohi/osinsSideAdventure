package flxnovel.objects.visualnovel.taleeditor;

import flixel.text.FlxText;
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

	public var lineText:FlxText;

	public var speakersDropdown:FlxUIDropDownMenu;
	public var onSpeakerChangeCallback:String->Int->Void;

	public var speakersStateInput:FlxUIInputText;
	public var onSpeakerStateChangeCallback:String->Int->Void;

	public var lineTextInput:FlxUIInputText;
	public var onLineTextChangeCallback:String->Int->Void;

	public var newLineBTN:FlxButton;
	public var onNewLineCallback:Void->Void;

	public var removeLineBTN:FlxButton;
	public var onRemoveLineCallback:Int->Void;

	public var autoSkipStepper:FlxUINumericStepper;
	public var onAutoSkipStepCallback:Float->Int->Void;

	public var bgTextInput:FlxUIInputText;
	public var onBGTextChangeCallback:String->Int->Void;

	override function create()
	{
		super.create();

		name = 'Lines';

		lineText = new FlxText(10, 20, 0, 'Selected Line: None', 16);
		lineText.ID = 0;

		var speakers = [for (speakerID in SpeakerData.speakers) new StrNameLabel(speakerID, speakerID)];
		speakers.insert(0, new StrNameLabel('', ''));

		speakersDropdown = new FlxUIDropDownMenu(lineText.x + lineText.width + 10, lineText.y, speakers, onSpeakerChange);
		speakersDropdown.selectedId = '';

		lineTextInput = new FlxUIInputText(speakersDropdown.x + speakersDropdown.width + 10, speakersDropdown.y, 320, '', 8);
		lineTextInput.callback = onLineTextChange;

		speakersStateInput = new FlxUIInputText(lineTextInput.x, lineTextInput.y + lineTextInput.height + 20, Math.round(lineTextInput.width), '',
			lineTextInput.size);
		speakersStateInput.callback = onSpeakerStateChange;

		bgTextInput = new FlxUIInputText(speakersStateInput.x, speakersStateInput.y + speakersStateInput.height + 20, Math.round(lineTextInput.width), '',
			lineTextInput.size);
		bgTextInput.callback = onLineBGTextChange;

		newLineBTN = new FlxButton(bgTextInput.x, bgTextInput.y + bgTextInput.height + 10, 'New Line', onNewLine);

		removeLineBTN = new FlxButton(newLineBTN.x + newLineBTN.width + 10, newLineBTN.y, 'Remove Line', onRemoveLine);

		autoSkipStepper = new FlxUINumericStepper(removeLineBTN.x + removeLineBTN.width + 10, removeLineBTN.y + 10, 0.1, 0, 0.0, 60.0, 1);
		autoSkipStepper.value = 0;
		autoSkipStepper.name = 'line_autoSkip';

		add(lineText);

		add(makeText(speakersDropdown, 'Line Speaker ID: '));
		add(speakersDropdown);

		add(makeText(lineTextInput, 'Line Text: '));
		add(lineTextInput);

		add(makeText(speakersStateInput, 'Line Speaker State: '));
		add(speakersStateInput);

		add(makeText(bgTextInput, 'Line BG: '));
		add(bgTextInput);

		add(newLineBTN);
		add(removeLineBTN);

		add(makeText(autoSkipStepper, 'Auto Skip Time (Seconds): '));
		add(autoSkipStepper);

		onSpeakerChange(speakersDropdown.selectedLabel);
	}

	public function onLineBGTextChange(text:String, action:String)
	{
		if (onBGTextChangeCallback != null)
			onBGTextChangeCallback(text, lineText.ID);
	}

	// small yoink from FNF legacy code
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		var index:Int = lineText.ID;

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
				onAutoSkipStepCallback(nums.value.roundDecimal(2), index);
		}
	}

	public function onSpeakerStateChange(text:String, action:String)
	{
		if (onSpeakerStateChangeCallback != null)
			onSpeakerStateChangeCallback(text, lineText.ID);
	}

	public function onRemoveLine()
	{
		if (onRemoveLineCallback != null)
			onRemoveLineCallback(lineText.ID);
	}

	public function onNewLine()
	{
		if (onNewLineCallback != null)
			onNewLineCallback();
	}

	public function onSpeakerChange(speakerID:String)
	{
		if (onSpeakerChangeCallback != null)
			onSpeakerChangeCallback(speakerID, lineText.ID);
	}

	public function onLineTextChange(text:String, action:String)
	{
		if (onLineTextChangeCallback != null)
			onLineTextChangeCallback(text, lineText.ID);
	}

	public function onChangedLine(indexStr:String)
	{
		lineText.text = 'Selected Line: ${(_tale?.lines?.length > 0) ? 0 : Std.parseInt(indexStr) + 1} / ${_tale?.lines?.length ?? 0}';

		onChangedLineBasic(indexStr);
		onChangedLineCallbacks();
	}

	public function onChangedLineBasic(indexStr:String)
	{
		trace('onChangedLineBasic');
		var line:TaleLineData = _tale?.lines[Std.parseInt(indexStr)] ?? null;

		lineTextInput.text = line?.text ?? '';
		bgTextInput.text = line?.background ?? '';

		speakersDropdown.selectedId = line?.speaker?.id ?? '';
		speakersStateInput.text = line?.speaker?.state ?? '';

		autoSkipStepper.value = line?.autoSkip ?? 0.0;
	}

	public function onChangedLineCallbacks()
	{
		trace('onChangedLineCallbacks');
		onLineBGTextChange(bgTextInput.text, '');
		onLineTextChange(lineTextInput.text, '');

		onSpeakerChange(speakersDropdown.selectedId);
		onSpeakerStateChange(speakersStateInput.text, '');
	}

	public function updateList()
	{
		onChangedLine('${lineText.ID}');
	}
}
