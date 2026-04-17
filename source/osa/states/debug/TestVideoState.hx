package osa.states.debug;

import osa.states.visualnovel.cutscenes.VideoCutscene;

class TestVideoState extends OSAState
{
    public var _video:VideoCutscene;

	override function create()
	{
		super.create();

        _video = new VideoCutscene();
        _video.play('testVid'.videoFile().miscAsset());

        add(_video);
	}
}
