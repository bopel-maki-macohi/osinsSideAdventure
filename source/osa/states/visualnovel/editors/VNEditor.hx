package osa.states.visualnovel.editors;

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
		var taleData:TaleData = new JsonParser<TaleData>().fromJson(file.data.toString(), file.name);

		_tale.build(taleData.iteration, taleData.lines, taleData.storymenu);

		uiBox.linesTabGroup.updateList();
	}
}
