package flxnovel.states.debug;

import flxnovel.objects.cutscenes.VideoCutscene;

class TestVideoState extends FlxNovelState
{
	public var video:VideoCutscene;

	override function create()
	{
		super.create();

		video = new VideoCutscene();
		video.play('testVid'.videoFile().miscAsset());

		add(video);
	}
}
