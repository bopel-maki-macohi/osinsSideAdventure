package osa.states.visualnovel;

import osa.modding.scripting.ScriptHandler;
import flixel.util.FlxColor;
import osa.objects.HoldToPerformGadge;
import osa.util.SoundUtil;
import osa.states.menus.TitleState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import osa.data.visualnovel.tales.TaleLineData;
import osa.objects.visualnovel.*;
import osa.data.visualnovel.*;

class VNState extends OSAState
{
	public var taleData:TaleData;

	public static var instance:VNState;

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

		trace('$taleID speakers: ${[for (id => speaker in speakers) id]}');
	}

	public var speakers:Map<String, SpeakerData> = [];

	public var textWriteDelay:Float = 0.03;
	public var textEraseDelay:Float = 0.015;

	public var dialogueText:FlxTypeText;
	public var finishedWriting:Bool = false;

	public var continueHand:FlxSprite;

	public var holdToSkipGadge:HoldToPerformGadge;

	public var speaker:VNSpeaker;

	public var lineNumber:Int = 0;

	public var line(get, never):TaleLineData;

	function get_line():TaleLineData
	{
		return taleData?.lines[lineNumber] ?? null;
	}

	override function create()
	{
		if (instance != null)
			instance = null;

		instance = this;

		speaker = new VNSpeaker(null);

		dialogueText = new FlxTypeText(0, 0, Math.round(FlxG.width / 1), '', 16);
		dialogueText.alignment = CENTER;
		dialogueText.y = 20;

		dialogueText.sounds = SoundUtil.getLoadedSoundsFromDirectory('typing/'.visualNovelAsset());

		continueHand = new FlxSprite(0, 0, 'continueHand'.imageFile().visualNovelAsset());

		continueHand.scale.set(2, 2);
		continueHand.updateHitbox();

		continueHand.setPosition(FlxG.width - continueHand.width * 2, FlxG.height - continueHand.height * 2);

		holdToSkipGadge = new HoldToPerformGadge(FlxColor.RED, function()
		{
			return controls.pressed.HOLD_SKIP;
		}, function()
		{
			endTale(false);
		});

		holdToSkipGadge.setPosition(continueHand.getGraphicMidpoint().x - holdToSkipGadge.width * .5,
			continueHand.getGraphicMidpoint().y - holdToSkipGadge.height * .5);

		add(speaker);
		add(dialogueText);
		add(continueHand);
		add(holdToSkipGadge);

		super.create();

		changeLine(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		dialogueText.screenCenter(X);

		continueHand.visible = finishedWriting;

		if (finishedWriting && controls.justPressed.ACCEPT)
			changeLine(1);
	}

	public function changeLine(increment:Int = 0)
	{
		if (lineNumber + increment < 0)
		{
			ScriptHandler.call('onAttemptedUnderflow', []);

			return;
		}

		if (lineNumber + increment >= taleData.lines.length)
		{
			endTale(true);

			return;
		}

		lineNumber += increment;

		writeDialogue();

		buildSpeaker();

		ScriptHandler.call('onChangedLine', [lineNumber]);
	}

	public function writeDialogue()
	{
		finishedWriting = false;

		dialogueText.resetText(line.text);
		dialogueText.start(textWriteDelay, true, false, [], finishWritingDialogue);

		ScriptHandler.call('onDialogueStartedWriting', []);
	}

	public function finishWritingDialogue()
	{
		finishedWriting = true;

		ScriptHandler.call('onDialogueFinishedWriting', []);
	}

	public function buildSpeaker()
	{
		if (line.speaker != null)
		{
			if (speaker?.data?.id != line.speaker.id)
			{
				speaker.build(null);
				speaker.data = speakers.get(line.speaker.id);
			}

			speaker.build(line.speaker.state);
		}
		else
		{
			speaker.visible = speaker.active = false;
		}

		speaker.screenCenter();

		ScriptHandler.call('onBuiltSpeaker', [speaker]);
	}

	public function endTale(validEnd:Bool)
	{
		ScriptHandler.call('onEndTale', [validEnd]);

		FlxG.switchState(() -> new TitleState());
	}
}
