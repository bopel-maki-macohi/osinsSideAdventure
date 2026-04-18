package osa.states.debug;

import osa.objects.cutscenes.VideoCutscene;

class TestVideoState extends OSAState
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
