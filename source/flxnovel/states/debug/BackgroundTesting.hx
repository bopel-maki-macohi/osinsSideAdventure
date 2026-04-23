package flxnovel.states.debug;

import flxnovel.states.menus.title.TitleState;
import flixel.FlxG;
import flxnovel.data.visualnovel.BackgroundData;
import flxnovel.objects.visualnovel.VNBackground;
import flxnovel.states.FlxNovelState;

class BackgroundTesting extends FlxNovelState
{
	public var bg:VNBackground;

	override function create()
	{
		super.create();

		bg = new VNBackground(BackgroundData.fileBuild('test'));
		add(bg);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.justPressed.LEAVE)
			FlxG.switchState(() -> new TitleState('DEBUGMENU'));
	}
}
