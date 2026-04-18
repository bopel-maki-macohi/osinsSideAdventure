package osa.states.menus;

import sys.FileStat;
import osa.data.visualnovel.TaleData;
import osa.states.visualnovel.VNState;
import flixel.FlxG;

class StoryMenuSubState extends TitleSubStateBase
{
	public static var entries(get, never):Array<String>;

	static function get_entries():Array<String>
		return 'story/tales'.menuAsset().textSplit();

	public static var entryData(get, never):Map<String, TaleData>;

	static function get_entryData():Map<String, TaleData>
	{
		var data:Map<String, TaleData> = [];

		for (entryID in StoryMenuSubState.entries)
		{
			var tale:TaleData = new TaleData(entryID.taleAsset().jsonFile());

			if (tale == null)
				continue;

			data.set(entryID, tale);
		}

		return data;
	}

	public static var filters(get, never):Array<String>;

	static function get_filters():Array<String>
	{
		var f = ['all'];

		for (entry => data in StoryMenuSubState.entryData)
		{
			if (data.storymenu?.filters.length > 0)
				for (filter in data.storymenu.filters)
					f.push(filter);
		}

		return f;
	}

	override public function create()
	{
		super.create();

		trace('filters: ' + StoryMenuSubState.filters);
		reload('debug');
	}

	public var currentFilter:String = '';

	public function reload(filter:String)
	{
		var targetTales = [for (entryID => tale in entryData) {entryID: entryID, tale: tale}];

		currentSelection = 0;

		spriteList = [];

		if (sprites != null)
		{
			sprites.setPosition();

			sprites.clear();
		}

		if (filter?.toLowerCase().trim() != null)
		{
			var filteredTargetTales = targetTales.filter(d -> return d.tale.storymenu?.filters.contains(filter));

			function setFilteredTales()
			{
				if (filteredTargetTales.length > 0)
				{
					targetTales = filteredTargetTales;
					currentFilter = filter;
				}
			}

			switch (filter.toLowerCase().trim())
			{
				case 'all', null, '':
					currentFilter = 'all';

				default:
					trace('Attempting filter: $filter');
					setFilteredTales();
			}
		}

		for (data in targetTales)
			addTale(data.tale, data.entryID);
		
		createSprites();
		changeSelection(0);
	}

	public function addTale(tale:TaleData, entryID:String)
	{
		spriteList.push(makeSprite('story/titles/${tale?.storymenu?.titleAsset ?? $entryID}', () -> setTaleString(tale, entryID), () -> taleSelected(entryID)));
	}

	public function setTaleString(tale:TaleData, entryID:String)
	{
		var msg:String = '';

		msg += 'Current Filter: ${currentFilter}\n';
		msg += '${tale?.storymenu?.display ?? entryID}';

		return msg;
	}

	public function taleSelected(tale:String)
	{
		FlxG.switchState(() -> new VNState(tale));
	}

	override function nonScrollingControls()
	{
		super.nonScrollingControls();

		if (controls.justPressed.UP || controls.justPressed.DOWN)
		{
			if (controls.justPressed.UP)
				reload(StoryMenuSubState.filters[StoryMenuSubState.filters.indexOf(currentFilter) - 1]);
			if (controls.justPressed.DOWN)
				reload(StoryMenuSubState.filters[StoryMenuSubState.filters.indexOf(currentFilter) + 1]);
		}
	}
}
