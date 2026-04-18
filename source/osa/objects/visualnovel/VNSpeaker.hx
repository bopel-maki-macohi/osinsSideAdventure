package osa.objects.visualnovel;

import osa.data.visualnovel.speaker.SpeakerStateData;
import flixel.FlxSprite;
import osa.data.visualnovel.SpeakerData;

class VNSpeaker extends FlxSprite
{
	public var data:SpeakerData = null;

	public var speaker:String = null;

	public function new(speaker:String, data:SpeakerData)
	{
		super();

		this.speaker = speaker;
		this.data = data;

		build(null);
	}

	public var state(default, null):String = null;

	public function build(state:String)
	{
		if (this.state == state)
			return;

		this.state = state;
		visible = active = true;

		final stateInfo:SpeakerStateData = data?.getStateInfo(state) ?? null;

		if (state == null || stateInfo == null || speaker == null)
		{
			visible = active = false;

			return;
		}

		loadGraphic(speaker.speakerAsset('imgs/${stateInfo.asset}').imageFile());
	}

    public function copy():VNSpeaker
    {
        return new VNSpeaker(speaker, data);
    }
}
