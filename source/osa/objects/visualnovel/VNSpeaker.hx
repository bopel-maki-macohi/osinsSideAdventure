package osa.objects.visualnovel;

import osa.data.visualnovel.speaker.SpeakerStateData;
import flixel.FlxSprite;
import osa.data.visualnovel.SpeakerData;

class VNSpeaker extends FlxSprite
{
	public var data:SpeakerData = null;

	public var speaker(get, never):String;

	function get_speaker():String
	{
		return data?.id;
	}

	public function new(data:SpeakerData)
	{
		super();

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
		trace('Copying $speaker');
		return new VNSpeaker(data);
	}

	public static function load(file:String) {}
}
