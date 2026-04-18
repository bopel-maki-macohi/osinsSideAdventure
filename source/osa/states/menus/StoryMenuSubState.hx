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

	override public function new(onExit:Void->Void)
	{
		super(onExit);

		trace('filters: ' + StoryMenuSubState.filters);
		reload('debug');
	}

	public function reload(filter:String)
	{
		var targetTales = [for (entryID => tale in entryData) {entryID: entryID, tale: tale}];

		if (filter.toLowerCase().trim() != null)
			switch (filter.toLowerCase().trim())
			{
				case 'all', null, '':

				default:
					trace('Attempting filter: $filter');
					targetTales = targetTales.filter(d -> return d.tale.storymenu?.filters.contains(filter));
			}

		for (data in targetTales)
		{
			addTale(data.tale, data.entryID);
		}
	}

	public function addTale(tale:TaleData, entryID:String)
	{
		spriteList.push(makeSprite('story/titles/${tale?.storymenu?.titleAsset}', function()
		{
			return '${tale?.storymenu?.titleAsset ?? entryID}';
		}, () -> taleSelected(entryID)));
	}

	public function taleSelected(tale:String)
	{
		FlxG.switchState(() -> new VNState(tale));
	}
}
