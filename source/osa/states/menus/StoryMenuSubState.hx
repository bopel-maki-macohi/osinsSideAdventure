package osa.states.menus;

import osa.states.visualnovel.VNState;
import flixel.FlxG;

class StoryMenuSubState extends TitleSubStateBase
{
	public static var entries(get, never):Array<String>;

	static function get_entries():Array<String>
	{
		return 'story/tales'.menuAsset().textSplit();
	}

	override public function new(onExit:Void->Void)
	{
		super(onExit);

		for (entry in entries)
			addTale(entry);
	}

	public function addTale(tale:String)
	{
		spriteList.push(makeSprite('story/titles/$tale', function()
		{
			return '$tale';
		}, () -> taleSelected(tale)));
	}

	public function taleSelected(tale:String)
	{
		FlxG.switchState(() -> new VNState(tale));
	}
}
