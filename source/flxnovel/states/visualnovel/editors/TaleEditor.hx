package flxnovel.states.visualnovel.editors;

import flxnovel.data.visualnovel.tales.ITaleContainer;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flxnovel.objects.visualnovel.VNSpeaker;
import flxnovel.util.Constants;
import flxnovel.data.visualnovel.SpeakerData;
import json2object.JsonParser;
import openfl.net.FileReference;
import flxnovel.objects.visualnovel.taleeditor.TaleEditorTabMenu;
import flxnovel.data.visualnovel.TaleData;
import flxnovel.states.menus.TitleState;
import flixel.FlxG;

class TaleEditor extends FlxNovelState implements ITaleContainer
{
	public var _tale:TaleData;

	public var uiBox:TaleEditorTabMenu;

	public var line_dialogueText:FlxText;
	public var line_speaker:VNSpeaker;

	public var talemenu_displayText:FlxText;
	public var talemenu_titleAsset:FlxSprite;

	override function create()
	{
		_tale = TaleData.fileBuild(null);
		_tale.talesmenu = {};

		uiBox = new TaleEditorTabMenu(_tale);

		line_dialogueText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		line_dialogueText.alignment = CENTER;

		talemenu_displayText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		talemenu_displayText.alignment = CENTER;

		talemenu_titleAsset = new FlxSprite();

		add(line_dialogueText);
		add(line_speaker = new VNSpeaker(null));

		add(talemenu_displayText);
		add(talemenu_titleAsset);

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

		uiBox.talesTabGroup.onTitleAssetChangeCallback = onTitleAssetChange;
		uiBox.talesTabGroup.onDisplayTextChangeCallback = onDisplayTextChange;
		uiBox.talesTabGroup.onAddFilterCallback = onNewFilter;
		uiBox.talesTabGroup.onRemoveFilterCallback = onRemoveFilter;

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

		line_speaker.applyOrientation();
		line_speaker.x += uiBox.width - (line_speaker.width / 2);

		talemenu_titleAsset.screenCenter();
		talemenu_titleAsset.x = FlxG.width - talemenu_titleAsset.width * 2;

		line_speaker.visible = (line_dialogueText.visible = uiBox.selected_tab == 1) && line_speaker.data != null;

		talemenu_titleAsset.visible = talemenu_displayText.visible = uiBox.selected_tab == 2;

		if (talemenu_titleAsset.visible)
			loadTaleMenuTitle();

		if (_tale.talesmenu?.display?.trim().length > 0)
		{
			talemenu_displayText.text = _tale.talesmenu?.display;
			talemenu_displayText.alpha = 1;
		}
		else
		{
			talemenu_displayText.text = uiBox.dataTabGroup._taleID;
			talemenu_displayText.alpha = .5;
		}

		if (controls.justPressed.LEAVE)
		{
			if (uiBox.dataTabGroup.taleIDInput.hasFocus)
				return;

			if (uiBox.linesTabGroup.textInput.hasFocus)
				return;
			if (uiBox.linesTabGroup.speakersStateInput.hasFocus)
				return;

			if (uiBox.talesTabGroup.filterInput.hasFocus)
				return;
			if (uiBox.talesTabGroup.displayInput.hasFocus)
				return;
			if (uiBox.talesTabGroup.titleAssetInput.hasFocus)
				return;

			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		}
	}

	public function loadTaleMenuTitle()
	{
		var path:String = 'tales/titles/'.menuAsset();

		if (_tale.talesmenu?.titleAsset?.trim().length > 0)
		{
			path += _tale.talesmenu.titleAsset;
			talemenu_titleAsset.alpha = 1;
		}
		else
		{
			path += uiBox.dataTabGroup._taleID.split('-')[0];
			talemenu_titleAsset.alpha = .5;
		}

		path = path.imageFile();
		if (path.fileExists())
		{
			talemenu_titleAsset.loadGraphic(path);
			
			talemenu_titleAsset.scale.set(.5, .5);
			talemenu_titleAsset.updateHitbox();

			talemenu_titleAsset.visible = true;
		}
		else
			talemenu_titleAsset.visible = false;
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
		if (_tale?.talesmenu?.filters == null || !_tale.talesmenu.filters.contains(filter))
			return;

		_tale.talesmenu.filters.remove(filter);

		refresh();

		uiBox.talesTabGroup.filtersDropdown.selectedId = uiBox.talesTabGroup.btnFilters[uiBox.talesTabGroup.btnFilters.length - 1]?.name;
	}

	function onNewFilter(filter:String)
	{
		if (_tale?.talesmenu == null)
			_tale.talesmenu = {};
		if (_tale?.talesmenu?.filters == null)
			_tale.talesmenu.filters = [];

		if (_tale.talesmenu.filters.contains(filter))
			return;

		_tale.talesmenu.filters.push(filter);

		refresh();

		uiBox.talesTabGroup.filtersDropdown.selectedId = uiBox.talesTabGroup.btnFilters[uiBox.talesTabGroup.btnFilters.length - 1]?.name;
	}

	function onDisplayTextChange(text:String)
	{
		_tale.talesmenu.display = text;
		refresh();
	}

	function onTitleAssetChange(text:String)
	{
		_tale.talesmenu.titleAsset = text;
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
			line_speaker.data = SpeakerData.fileBuild(newSpeaker);

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
			_tale.build(taleData.iteration, taleData.lines, taleData.talesmenu, taleData.generatedBy);
		}

		refresh();
	}

	function refresh()
	{
		uiBox.linesTabGroup.updateList();
		uiBox.talesTabGroup.updateList();
	}
}
