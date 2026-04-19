package osa.states.visualnovel.editors;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import osa.objects.visualnovel.VNSpeaker;
import osa.util.Constants;
import osa.data.visualnovel.SpeakerData;
import json2object.JsonParser;
import openfl.net.FileReference;
import osa.objects.visualnovel.taleeditor.TabMenu;
import osa.data.visualnovel.TaleData;
import osa.states.menus.TitleState;
import flixel.FlxG;

class TaleEditor extends OSAState
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
		uiBox.linesTabGroup.onSpeakerStateChangeCallback = onLineSpeakerStateChange;
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

		refresh();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		uiBox._tale = _tale;

		dialogueText.screenCenter(X);

		speaker.screenCenter();
		speaker.x = FlxG.width - speaker.width * 2;

		speaker.visible = (dialogueText.visible = uiBox.selected_tab == 1) && speaker.data != null;

		if (controls.justPressed.LEAVE)
		{
			if (uiBox.dataTabGroup.taleID.hasFocus)
				return;

			if (uiBox.linesTabGroup.textInput.hasFocus)
				return;
			if (uiBox.linesTabGroup.speakersStateInput.hasFocus)
				return;

			if (uiBox.storyTabGroup.filterInput.hasFocus)
				return;
			if (uiBox.storyTabGroup.displayInput.hasFocus)
				return;
			if (uiBox.storyTabGroup.titleAssetInput.hasFocus)
				return;

			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		}
	}

	function onLineSpeakerStateChange(text:String, index:Int)
	{
		if (_tale.lines[index].speaker == null)
		{
			_tale.lines[index].speaker = {
				id: uiBox.linesTabGroup.speakersDropdown.selectedId,
				state: text,
			}
		}
		else
			_tale.lines[index].speaker.state = text;

		if (speaker?.data?.hasStateID(text) && speaker.state != null)
		{
			uiBox.linesTabGroup.speakersStateInput.color = FlxColor.GREEN;
			speaker.build(text);
		}
		else if (speaker?.data?.hasStateIDLowercase(text) && speaker.state != null)
			uiBox.linesTabGroup.speakersStateInput.color = FlxColor.YELLOW;
		else
			uiBox.linesTabGroup.speakersStateInput.color = FlxColor.RED;
	}

	function onRemoveFilter(filter:String)
	{
		if (_tale?.storymenu?.filters == null || !_tale.storymenu.filters.contains(filter))
			return;

		_tale.storymenu.filters.remove(filter);

		refresh();

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

		refresh();

		uiBox.storyTabGroup.filtersDropdown.selectedId = uiBox.storyTabGroup.btnFilters[uiBox.storyTabGroup.btnFilters.length - 1]?.name;
	}

	function onDisplayTextChange(text:String)
	{
		_tale.storymenu.display = text;
		refresh();
	}

	function onTitleAssetChange(text:String)
	{
		_tale.storymenu.titleAsset = text;
		refresh();
	}

	function onRemoveLine(index:Int)
	{
		_tale.lines.remove(_tale.lines[index]);

		refresh();

		var ldd = uiBox.linesTabGroup.linesDropdown;

		ldd.selectedId = (ldd.list[index - 1] ?? ldd.list[ldd.list.length - 1])?.name ?? '0';
	}

	function onNewLine()
	{
		_tale.lines.push({
			text: '',
			speaker: {
				id: 'test',
				state: 'default',
			}
		});

		refresh();

		var ldd = uiBox.linesTabGroup.linesDropdown;

		ldd.selectedId = ldd.list[ldd.list.length - 1]?.name ?? '0';
	}

	function onLineSpeakerChange(newSpeaker:String, index:Int)
	{
		if (_tale.lines[index] == null)
			onLineTextChange(uiBox.linesTabGroup.textInput.text, index);

		if (newSpeaker == '' || newSpeaker == null)
		{
			uiBox.linesTabGroup.speakersStateInput.text = '';

			speaker.build(null);
			speaker.data = null;

			_tale.lines[index].speaker = null;
		}
		else
		{
			speaker.data = new SpeakerData(newSpeaker, newSpeaker.speakerAsset('data'.jsonFile()));

			if (_tale.lines[index].speaker == null)
			{
				_tale.lines[index].speaker = {
					id: newSpeaker,
					state: speaker.data.states[0]?.id ?? '',
				}
			}
			else
			{
				_tale.lines[index].speaker.id = newSpeaker;

				if (!speaker.data.hasStateID(_tale.lines[index].speaker.state))
					_tale.lines[index].speaker.state = speaker.data.states[0]?.id ?? '';
			}

			speaker.build(_tale.lines[index].speaker.state);
		}

		refresh();
	}

	function onLineTextChange(newText:String, index:Int)
	{
		if (_tale.lines[index] == null)
		{
			_tale.lines[index] = {
				text: newText,
			};
		}
		else
		{
			_tale.lines[index].text = newText;
		}

		dialogueText.text = newText;
		refresh();
	}

	function loadTale(file:FileReference)
	{
		if (file != null)
		{
			var taleData:TaleData = new JsonParser<TaleData>().fromJson(file.data.toString(), file.name);
			_tale.build(taleData.iteration, taleData.lines, taleData.storymenu, taleData.generatedBy);
		}

		refresh();
	}

	function refresh()
	{
		uiBox.linesTabGroup.updateList();
		uiBox.storyTabGroup.updateList();
	}
}
