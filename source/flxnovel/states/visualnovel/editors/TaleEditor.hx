package flxnovel.states.visualnovel.editors;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flxnovel.objects.visualnovel.VNBackground;
import flxnovel.data.visualnovel.BackgroundData;
import flxnovel.util.plugins.VolumeManagerPlugin;
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
import flixel.addons.ui.FlxUIInputText;

class TaleEditor extends FlxNovelState implements ITaleContainer
{
	public var _tale:TaleData;

	public var uiBox:TaleEditorTabMenu;

	public var line_dialogueText:FlxText;
	public var dialogueTextBG:FlxSprite;

	public var line_speaker:VNSpeaker;
	public var line_background:VNBackground;

	public var talemenu_displayText:FlxText;
	public var talemenu_titleAsset:FlxSprite;

	override function onExit()
	{
		super.onExit();

		Main.debugDisplay.changeVerticalOrientation(this.transOut.duration);
	}

	override function create()
	{
		Main.debugDisplay.changeVerticalOrientation(this.transIn.duration);

		_tale = TaleData.fileBuild(null);
		_tale.talesmenu = {};

		uiBox = new TaleEditorTabMenu(_tale);

		line_dialogueText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		line_dialogueText.alignment = CENTER;

		dialogueTextBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		dialogueTextBG.alpha = .1;

		talemenu_displayText = new FlxText(0, 20, Math.round(FlxG.width / 1), '', 16);
		talemenu_displayText.alignment = CENTER;

		talemenu_titleAsset = new FlxSprite();

		add(line_background = new VNBackground(null));
		add(line_speaker = new VNSpeaker(null));
		add(dialogueTextBG);
		add(line_dialogueText);

		add(talemenu_displayText);
		add(talemenu_titleAsset);

		add(uiBox);

		uiBox.dataTabGroup.loadJSONCallback = loadTale;
		uiBox.dataTabGroup.saveJSONPreCallback = function()
		{
			_tale.generatedBy = Constants.GENERATED_BY;
		};

		uiBox.linesTabGroup.onLineTextChangeCallback = onLineTextChange;
		uiBox.linesTabGroup.onSpeakerStateChangeCallback = onLineSpeakerStateChange;
		uiBox.linesTabGroup.onSpeakerChangeCallback = onLineSpeakerChange;
		uiBox.linesTabGroup.onSpeakerStateChangeCallback = onLineSpeakerStateChange;
		uiBox.linesTabGroup.onNewLineCallback = onNewLine;
		uiBox.linesTabGroup.onRemoveLineCallback = onRemoveLine;
		uiBox.linesTabGroup.onAutoSkipStepCallback = onAutoSkipStep;
		uiBox.linesTabGroup.onBGTextChangeCallback = onLineBGTextChange;

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

		dialogueTextBG.scale.set(line_dialogueText.width, line_dialogueText.height);
		dialogueTextBG.updateHitbox();

		dialogueTextBG.x = line_dialogueText.x;
		dialogueTextBG.y = line_dialogueText.y;

		line_speaker.applyOrientation();
		line_speaker.x += uiBox.width - (line_speaker.width / 2);

		talemenu_titleAsset.screenCenter();
		talemenu_titleAsset.x = FlxG.width - talemenu_titleAsset.width * 2;

		line_speaker.visible = (line_dialogueText.visible = uiBox.selected_tab == 1) && line_speaker.data != null && line_speaker.active;

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

		VolumeManagerPlugin.volumeKeysActive = true;
		for (inputText in typingInputs)
			if (inputText.hasFocus)
				VolumeManagerPlugin.volumeKeysActive = false;

		if (controls.justPressed.LEAVE)
		{
			for (inputText in typingInputs)
				if (inputText.hasFocus)
					return;

			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
		}
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		super.getEvent(id, sender, data, params);

		uiBox?.dataTabGroup?.getEvent(id, sender, data, params);
		uiBox?.linesTabGroup?.getEvent(id, sender, data, params);
		uiBox?.talesTabGroup?.getEvent(id, sender, data, params);
	}

	public var typingInputs(get, never):Array<FlxUIInputText>;

	function get_typingInputs():Array<FlxUIInputText>
	{
		return [
			uiBox.dataTabGroup.taleIDInput,

			uiBox.linesTabGroup.lineTextInput,
			uiBox.linesTabGroup.speakersStateInput,
			uiBox.linesTabGroup.bgTextInput,

			uiBox.talesTabGroup.filterInput,
			uiBox.talesTabGroup.displayInput,
			uiBox.talesTabGroup.titleAssetInput,
		];
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

	function onLineBGTextChange(text:String, index:Int)
	{
		if (_tale.lines[index] == null)
			addNewLineTo(index);

		_tale.lines[index].background = text;

		line_background.visible = false;
		if (BackgroundData.backgrounds.contains(text))
		{
			uiBox.linesTabGroup.bgTextInput.color = FlxColor.GREEN;

			line_background.data = BackgroundData.fileBuild(text);
			line_background.build();
			line_background.visible = true;
		}
		else if (BackgroundData.backgroundsLowercase.contains(text.toLowerCase()))
			uiBox.linesTabGroup.speakersStateInput.color = FlxColor.YELLOW;
		else
			uiBox.linesTabGroup.bgTextInput.color = FlxColor.RED;
	}

	function onAutoSkipStep(value:Float, index:Int)
	{
		if (_tale.lines[index] == null)
			addNewLineTo(index);

		_tale.lines[index].autoSkip = value;

		refresh();
	}

	function onLineSpeakerStateChange(text:String, index:Int)
	{
		if (_tale.lines[index]?.speaker == null)
		{
			if (_tale.lines[index] == null)
			{
				_tale.lines[index] = {
					text: uiBox.linesTabGroup.lineTextInput.text
				};
			}

			_tale.lines[index].speaker = {
				id: uiBox.linesTabGroup.speakersDropdown.selectedId,
				state: text,
			}
		}
		else
			_tale.lines[index].speaker.state = text;

		line_speaker.active = false;
		if (line_speaker?.data?.hasStateID(text) && line_speaker.state != null)
		{
			uiBox.linesTabGroup.speakersStateInput.color = FlxColor.GREEN;

			line_speaker.build(text);
			line_speaker.active = true;
		}
		else if (line_speaker?.data?.hasStateIDLowercase(text.toLowerCase()) && line_speaker.state != null)
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

	function addNewLineTo(index:Int)
	{
		if (index > 0)
			_tale.lines[index] = {
				text: uiBox.linesTabGroup.bgTextInput.text,
				speaker: {
					id: uiBox.linesTabGroup.speakersDropdown.selectedId,
					state: uiBox.linesTabGroup.speakersStateInput.text,
				},
				autoSkip: uiBox.linesTabGroup.autoSkipStepper.value,
				background: uiBox.linesTabGroup.bgTextInput.text
			};

		refresh();
	}

	function onNewLine()
	{
		addNewLineTo(_tale.lines.length);

		var ldd = uiBox.linesTabGroup.linesDropdown;

		ldd.selectedId = ldd.list[ldd.list.length - 1]?.name ?? '0';
	}

	function onLineSpeakerChange(newSpeaker:String, index:Int)
	{
		if (_tale.lines[index] == null)
			onLineTextChange(uiBox.linesTabGroup.bgTextInput.text, index);

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

		uiBox.linesTabGroup.onChangedLineBasic(uiBox.linesTabGroup.linesDropdown.selectedId);

		onLineSpeakerStateChange(uiBox.linesTabGroup.speakersStateInput.text, Std.parseInt(uiBox.linesTabGroup.linesDropdown.selectedId));
	}
}
