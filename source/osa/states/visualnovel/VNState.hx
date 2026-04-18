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

			speakers.set(taleLine.speaker.id, new VNSpeaker(taleLine.speaker.id, new SpeakerData('${taleLine.speaker.id}'.jsonFile().speakerAsset('data'))));
		}

		trace('Speakers: ${[for (speaker in speakers) speaker]}');
	}

	public var speakers:Map<String, VNSpeaker> = [];

	public var speaker:VNSpeaker;

	override function create()
	{
		speaker = new VNSpeaker(null, null);
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

		if (line.speaker != null)
		{
			speaker = speakers.get(line.speaker.id).copy();
		}
		else
		{
			speaker.visible = speaker.active = false;
		}
	}
}
