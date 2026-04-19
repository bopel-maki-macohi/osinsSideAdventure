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
		_tale = new TaleData('lorem'.taleAsset().jsonFile());

		add(uiBox = new TabMenu(_tale));

		uiBox.dataTabGroup.loadJSONCallback = loadTale;

		loadTale(null);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		uiBox._tale = _tale;

		if (controls.justPressed.LEAVE)
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
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
