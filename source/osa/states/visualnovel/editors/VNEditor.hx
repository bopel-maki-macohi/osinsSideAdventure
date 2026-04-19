package osa.states.visualnovel.editors;

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

		add(uiBox = new TabMenu(_tale));

		uiBox.dataTabGroup.loadJSONCallback = loadTale;

		uiBox.linesTabGroup.onTextChangeCallback = onLineTextChange;
		uiBox.linesTabGroup.onSpeakerChangeCallback = onLineSpeakerChange;

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
			_tale.build(taleData.iteration, taleData.lines, taleData.storymenu);
		}

		uiBox.linesTabGroup.updateList();
	}
}
