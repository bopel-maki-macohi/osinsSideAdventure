package flxnovel.states.visualnovel;

import flxnovel.util.ISingletonManual;
import flxnovel.data.visualnovel.tales.ITaleContainer;
import flxnovel.modding.scripting.ScriptHandler;
import flixel.util.FlxColor;
import flxnovel.objects.HoldToPerformGadge;
import flxnovel.util.SoundUtil;
import flxnovel.states.menus.TitleState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import flxnovel.data.visualnovel.tales.TaleLineData;
import flxnovel.objects.visualnovel.*;
import flxnovel.data.visualnovel.*;
import flixel.util.FlxTimer;

class VNState extends FlxNovelState implements ITaleContainer implements ISingletonManual
{
	public var _tale:TaleData;

	override public function new(taleID:String)
	{
		super();

		_tale = TaleData.fileBuild(taleID);

		for (taleLine in _tale.lines)
		{
			if (taleLine.speaker == null)
				continue;
			if (speakers.exists(taleLine.speaker.id))
				continue;
			if (taleLine.speaker.id.trim().length < 1)
				continue;

			speakers.set(taleLine.speaker.id, SpeakerData.fileBuild(taleLine.speaker.id));
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
		return _tale?.lines[lineNumber] ?? null;
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

		if (lineNumber + increment >= _tale.lines.length)
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
		if (line.autoSkip != null && line.autoSkip > 0)
		{
			FlxTimer.wait(line.autoSkip, autoSkipDialogue);
		}
		else
		{
			finishedWriting = true;
		}

		ScriptHandler.call('onDialogueFinishedWriting', []);
	}

	public function autoSkipDialogue()
	{
		changeLine(1);

		ScriptHandler.call('onDialogueAutoSkip', []);
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

		speaker.applyOrientation();

		ScriptHandler.call('onBuiltSpeaker', [speaker]);
	}

	public function endTale(validEnd:Bool)
	{
		ScriptHandler.call('onEndTale', [validEnd]);

		FlxG.switchState(() -> new TitleState('TALESMENU'));
	}
}
