package flxnovel.states.debug;

import flxnovel.data.visualnovel.BackgroundData;
import flxnovel.objects.visualnovel.VNBackground;
import flxnovel.states.FlxNovelState;

class BackgroundTesting extends FlxNovelState
{
	public var bg:VNBackground;

	override function create()
	{
		super.create();

		bg = new VNBackground(BackgroundData.fileBuild('void'));
		add(bg);
	}
}
