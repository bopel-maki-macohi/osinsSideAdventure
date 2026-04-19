package osa.states.visualnovel.editors;

import osa.util.Constants;
import osa.data.visualnovel.SpeakerData;
import json2object.JsonParser;
import openfl.net.FileReference;
import osa.objects.visualnovel.editors.TabMenu;
import osa.data.visualnovel.TaleData;
import osa.states.menus.TitleState;
import flixel.FlxG;

class VNEditor extends OSAState
{
	public var _tale:TaleData;

	public var uiBox:TabMenu;

	override function create()
	{
		_tale = new TaleData(null);
		// onNewLine();

		add(uiBox = new TabMenu(_tale));

		uiBox.dataTabGroup.loadJSONCallback = loadTale;
		uiBox.dataTabGroup.saveJSONPreCallback = function()
		{
			_tale.generatedBy = Constants.GENERATED_BY;
		};

		uiBox.linesTabGroup.onTextChangeCallback = onLineTextChange;
		uiBox.linesTabGroup.onSpeakerChangeCallback = onLineSpeakerChange;
		uiBox.linesTabGroup.onSpeakerStateChangeCallback = onLineSpeakerStateChange;
		uiBox.linesTabGroup.onNewLineCallback = onNewLine;
		uiBox.linesTabGroup.onRemoveLineCallback = onRemoveLine;

		super.create();

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		uiBox._tale = _tale;

		if (controls.justPressed.LEAVE)
		{
			if (uiBox.dataTabGroup.taleID.hasFocus)
				return;
			if (uiBox.linesTabGroup.textInput.hasFocus)
				return;

			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		}
	}

	function onRemoveLine(index:Int)
	{
		if (_tale.lines[index] == null)
			return;

		_tale.lines.remove(_tale.lines[index]);

		loadTale(null);

		if (_tale.lines.length == 0 || index - 1 <= 0)
			uiBox.linesTabGroup.linesDropdown.selectedId = '0';
		else
			uiBox.linesTabGroup.linesDropdown.selectedId = '${index - 1}';
	}

	function onNewLine()
	{
		_tale.lines.push({
			text: '',
		});

		loadTale(null);

		uiBox.linesTabGroup.linesDropdown.selectedId = '${uiBox.linesTabGroup.linesDropdown.list.length}';
	}

	function onLineSpeakerStateChange(newState:String, index:Int)
	{
		if (_tale.lines[index]?.speaker == null)
			onLineSpeakerChange(uiBox.linesTabGroup.speakersDropdown.selectedLabel, index);

		_tale.lines[index].speaker.state = newState;
	}

	function onLineSpeakerChange(newSpeaker:String, index:Int)
	{
		if (_tale.lines[index] == null)
			onLineTextChange(uiBox.linesTabGroup.textInput.text, index);

		_tale.lines[index].speaker = {
			id: newSpeaker,
			state: new SpeakerData(newSpeaker, newSpeaker.speakerAsset('data'.jsonFile())).states[0].id,
		}
	}

	function onLineTextChange(newText:String, index:Int)
	{
		if (_tale.lines[index] == null)
		{
			_tale.lines[index] = {
				text: newText,
			};

			loadTale(null);
		}
		else
		{
			_tale.lines[index].text = newText;
		}
	}

	function loadTale(file:FileReference)
	{
		if (file != null)
		{
			var taleData:TaleData = new JsonParser<TaleData>().fromJson(file.data.toString(), file.name);
			_tale.build(taleData.iteration, taleData.lines, taleData.storymenu, taleData.generatedBy);
		}

		uiBox.linesTabGroup.updateList();
	}
}
