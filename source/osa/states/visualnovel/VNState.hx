package osa.states.visualnovel;

import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
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

	public var textWriteDelay:Float = 0.03;
	public var textEraseDelay:Float = 0.015;

	public var dialogueText:FlxTypeText;
	public var finishedWriting:Bool = false;

	public var speaker:VNSpeaker;

	public var lineNumber:Int = 0;

	public var line(get, never):TaleLineData;

	function get_line():TaleLineData
	{
		return taleData?.lines[lineNumber] ?? null;
	}

	override function create()
	{
		speaker = new VNSpeaker(null);

		dialogueText = new FlxTypeText(0, 0, FlxG.width, '', 16);
		dialogueText.alignment = CENTER;
		dialogueText.y = 30;

		add(speaker);
		add(dialogueText);

		super.create();

		changeLine(0);
	}

	public function changeLine(increment:Int = 0)
	{
		lineNumber += increment;

		writeDialogue();

		buildSpeaker();
	}

	public function writeDialogue()
	{
		finishedWriting = false;

		dialogueText.resetText(line.text);
		dialogueText.start(textWriteDelay, true, false, [], finishWritingDialogue);
	}

	public function finishWritingDialogue()
	{
		finishedWriting = true;
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
