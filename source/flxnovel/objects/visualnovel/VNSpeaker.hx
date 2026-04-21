package flxnovel.objects.visualnovel;

import flixel.FlxG;
import flxnovel.data.visualnovel.speaker.SpeakerStateData;
import flixel.FlxSprite;
import flxnovel.data.visualnovel.SpeakerData;

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

		loadGraphic(speaker.visualNovelSpeakerAsset('imgs/${stateInfo.asset}').imageFile());
		offset.set(stateInfo?.offsets[0] ?? 0, stateInfo?.offsets[1] ?? 0);
	}

	public dynamic function applyOrientation()
	{
		screenCenter();
		switch (data?.config?.orientation)
		{
			case bottom:
				y = FlxG.height - this.height;

			case center:
		}
	}

	public function copy():VNSpeaker
	{
		trace('Copying $speaker');
		return new VNSpeaker(data);
	}

	public static function load(file:String) {}
}
