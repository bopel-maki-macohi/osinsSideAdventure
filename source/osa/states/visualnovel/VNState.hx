package osa.states.visualnovel;

import osa.data.visualnovel.tales.TaleLineData;
import osa.objects.visualnovel.*;
import osa.data.visualnovel.*;

class VNState extends OSAState
{
	public var taleData:TaleData;

	override public function new(taleID:String)
	{
		super();

		taleData = new TaleData(taleID.jsonFile().taleAsset());

		for (taleLine in taleData.lines)
		{
			if (taleLine.speaker == null)
				continue;
			if (speakers.exists(taleLine.speaker.id))
				continue;

			speakers.set(taleLine.speaker.id, new SpeakerData(taleLine.speaker.id, taleLine.speaker.id.speakerAsset('data'.jsonFile())));
		}

		trace('Speakers: ${[for (id => speaker in speakers) id]}');
	}

	public var speakers:Map<String, SpeakerData> = [];

	public var speaker:VNSpeaker;

	override function create()
	{
		speaker = new VNSpeaker(null);
		add(speaker);

		super.create();

		changeLine(0);
	}

	public var lineNumber:Int = 0;

	public var line(get, never):TaleLineData;

	function get_line():TaleLineData
	{
		return taleData?.lines[lineNumber] ?? null;
	}

	public function changeLine(increment:Int = 0)
	{
		lineNumber += increment;

		buildSpeaker();
	}

	public function buildSpeaker()
	{
		if (line.speaker != null)
		{
			speaker.data = speakers.get(line.speaker.id);
			speaker.build(line.speaker.state);
		}
		else
		{
			speaker.visible = speaker.active = false;
		}

		speaker.screenCenter();
	}
}
