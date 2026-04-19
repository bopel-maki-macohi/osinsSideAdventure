package osa.states.visualnovel.editors;

import flixel.text.FlxText;
import osa.objects.visualnovel.VNSpeaker;
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

	public var dialogueText:FlxText;

	public var speaker:VNSpeaker;

	override function create()
	{
		_tale = new TaleData(null);
		_tale.storymenu = {};

		uiBox = new TabMenu(_tale);

		dialogueText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		dialogueText.alignment = CENTER;

		add(dialogueText);
		add(speaker = new VNSpeaker(null));

		add(uiBox);

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

		uiBox.storyTabGroup.onTitleAssetChangeCallback = onTitleAssetChange;
		uiBox.storyTabGroup.onDisplayTextChangeCallback = onDisplayTextChange;
		uiBox.storyTabGroup.onAddFilterCallback = onNewFilter;
		uiBox.storyTabGroup.onRemoveFilterCallback = onRemoveFilter;

		onNewLine();
		uiBox.linesTabGroup.onChangedLine('0');

		super.create();

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		uiBox._tale = _tale;

		dialogueText.screenCenter(X);

		speaker.screenCenter();
		speaker.x = FlxG.width - speaker.width * 2;

		if (controls.justPressed.LEAVE)
		{
			if (uiBox.dataTabGroup.taleID.hasFocus)
				return;
			if (uiBox.linesTabGroup.textInput.hasFocus)
				return;

			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		}
	}

	function onRemoveFilter(filter:String)
	{
		if (_tale?.storymenu?.filters == null || !_tale.storymenu.filters.contains(filter))
			return;

		_tale.storymenu.filters.remove(filter);

		loadTale(null);

		uiBox.storyTabGroup.filtersDropdown.selectedId = uiBox.storyTabGroup.btnFilters[uiBox.storyTabGroup.btnFilters.length - 1]?.name;
	}

	function onNewFilter(filter:String)
	{
		if (_tale?.storymenu == null)
			_tale.storymenu = {};
		if (_tale?.storymenu?.filters == null)
			_tale.storymenu.filters = [];

		if (_tale.storymenu.filters.contains(filter))
			return;

		_tale.storymenu.filters.push(filter);

		loadTale(null);

		uiBox.storyTabGroup.filtersDropdown.selectedId = uiBox.storyTabGroup.btnFilters[uiBox.storyTabGroup.btnFilters.length - 1]?.name;
	}

	function onDisplayTextChange(text:String)
	{
		_tale.storymenu.display = text;
	}

	function onTitleAssetChange(text:String)
	{
		_tale.storymenu.titleAsset = text;
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

		speaker.build(newState);
	}

	function onLineSpeakerChange(newSpeaker:String, index:Int)
	{
		if (_tale.lines[index] == null)
			onLineTextChange(uiBox.linesTabGroup.textInput.text, index);

		speaker.data = new SpeakerData(newSpeaker, newSpeaker.speakerAsset('data'.jsonFile()));

		_tale.lines[index].speaker = {
			id: newSpeaker,
			state: speaker.data.states[0].id,
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

		dialogueText.text = newText;
	}

	function loadTale(file:FileReference)
	{
		if (file != null)
		{
			var taleData:TaleData = new JsonParser<TaleData>().fromJson(file.data.toString(), file.name);
			_tale.build(taleData.iteration, taleData.lines, taleData.storymenu, taleData.generatedBy);
		}

		uiBox.linesTabGroup.updateList();
		uiBox.storyTabGroup.updateList();
	}
}
