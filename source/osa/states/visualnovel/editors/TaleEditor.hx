package osa.states.visualnovel.editors;

import flixel.FlxSprite;
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

	public var line_dialogueText:FlxText;
	public var line_speaker:VNSpeaker;

	public var storymenu_displayText:FlxText;
	public var storymenu_titleAsset:FlxSprite;

	override function create()
	{
		_tale = new TaleData(null);
		_tale.storymenu = {};

		uiBox = new TabMenu(_tale);

		line_dialogueText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		line_dialogueText.alignment = CENTER;

		storymenu_displayText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		storymenu_displayText.alignment = CENTER;

		storymenu_titleAsset = new FlxSprite();

		add(line_dialogueText);
		add(line_speaker = new VNSpeaker(null));

		add(storymenu_displayText);
		add(storymenu_titleAsset);

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

		line_dialogueText.screenCenter(X);

		line_speaker.screenCenter(Y);
		line_speaker.x = FlxG.width - line_speaker.width * 2;

		storymenu_titleAsset.screenCenter();
		storymenu_titleAsset.x = FlxG.width - storymenu_titleAsset.width * 2;

		line_speaker.visible = (line_dialogueText.visible = uiBox.selected_tab == 1) && line_speaker.data != null;

		storymenu_titleAsset.visible = storymenu_displayText.visible = uiBox.selected_tab == 2;

		if (storymenu_titleAsset.visible)
			loadStorymenuTitle();

		if (_tale.storymenu?.display?.trim().length > 0)
		{
			storymenu_displayText.text = _tale.storymenu?.display;
			storymenu_displayText.alpha = 1;
		}
		else
		{
			storymenu_displayText.text = uiBox.dataTabGroup._taleID;
			storymenu_displayText.alpha = .5;
		}

		if (controls.justPressed.LEAVE)
		{
			if (uiBox.dataTabGroup.taleIDInput.hasFocus)
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

	public function loadStorymenuTitle()
	{
		var path:String = 'story/titles/'.menuAsset();

		if (_tale.storymenu?.titleAsset?.trim().length > 0)
		{
			path += _tale.storymenu.titleAsset;
			storymenu_titleAsset.alpha = 1;
		}
		else
		{
			path += uiBox.dataTabGroup._taleID.split('-')[0];
			storymenu_titleAsset.alpha = .5;
		}

		path = path.imageFile();
		if (path.fileExists())
		{
			storymenu_titleAsset.loadGraphic(path);
			
			storymenu_titleAsset.scale.set(.5, .5);
			storymenu_titleAsset.updateHitbox();

			storymenu_titleAsset.visible = true;
		}
		else
			storymenu_titleAsset.visible = false;
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

		if (line_speaker?.data?.hasStateID(text) && line_speaker.state != null)
		{
			uiBox.linesTabGroup.speakersStateInput.color = FlxColor.GREEN;
			line_speaker.build(text);
		}
		else if (line_speaker?.data?.hasStateIDLowercase(text) && line_speaker.state != null)
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

			line_speaker.build(null);
			line_speaker.data = null;

			_tale.lines[index].speaker = null;
		}
		else
		{
			line_speaker.data = new SpeakerData(newSpeaker, newSpeaker.speakerAsset('data'.jsonFile()));

			if (_tale.lines[index].speaker == null)
			{
				_tale.lines[index].speaker = {
					id: newSpeaker,
					state: line_speaker.data.states[0]?.id ?? '',
				}
			}
			else
			{
				_tale.lines[index].speaker.id = newSpeaker;

				if (!line_speaker.data.hasStateID(_tale.lines[index].speaker.state))
					_tale.lines[index].speaker.state = line_speaker.data.states[0]?.id ?? '';
			}

			line_speaker.build(_tale.lines[index].speaker.state);
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

		line_dialogueText.text = newText;
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
