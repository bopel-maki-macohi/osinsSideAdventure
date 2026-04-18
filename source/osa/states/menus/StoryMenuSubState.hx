package osa.states.menus;

import osa.data.visualnovel.TaleData;
import osa.states.visualnovel.VNState;
import flixel.FlxG;

class StoryMenuSubState extends TitleSubStateBase
{
	public static var entries(get, never):Array<String>;

	static function get_entries():Array<String>
		return 'story/tales'.menuAsset().textSplit();

	public var filters:Array<String> = ['all'];

	override public function new(onExit:Void->Void)
	{
		super(onExit);

		for (entryID in entries)
		{
			var tale:TaleData = new TaleData(entryID.taleAsset().jsonFile());

			addTale(tale, entryID);
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
