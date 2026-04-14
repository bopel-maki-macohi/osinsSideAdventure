package osa.states.visualnovel;

import osa.states.visualnovel.events.BonusIssue1EndSequence;
import osa.states.visualnovel.events.*;
import osa.states.visualnovel.events.DialogueTweaks;
import flixel.group.FlxSpriteGroup;

class EventManager extends FlxSpriteGroup
{
	public static var events:Map<String, EventRunner> = [
		'testingEventSystem' => new TestingEventSystem(NONE),
		'setDialogueSpeed' => new SetDialogueSpeed(),
		'resetDialogueSpeed' => new ResetDialogueSpeed(),
		'setDialogueBoxHeightPadding' => new SetDialogueBoxHeightPadding(),
		'issue1Intro' => new Issue1Intro(),
		'issue1EstablishingShot' => new Issue1EstablishingShot(),
		'issue2EndSequence' => new Issue2EndSequence(),
		'bonusissue1EndSequence' => new BonusIssue1EndSequence(),
		'issue3EndingSequence' => new Issue3EndingSequence(),
		'issue4' => new Issue4(),
	];

	public function new()
	{
		super();
	}

	public var _currentEvent:String = null;

	public function runDialogueEvent(event:String, ?params:Array<String>):Bool
	{
		this._currentEvent = event;

		visible = true;
		if (event == null)
		{
			visible = false;
			return false;
		}

		if (events.exists(event))
		{
			trace('Running dialogue event: $event');
			events.get(event)?.runDialogueEvent(this, params);
			return true;
		}

		return false;
	}

	function runOnEvents(f:EventRunner->Void)
	{
		for (event in events)
		{
			switch (event._dialogueFileType)
			{
				case ANY:
					f(event);

				case SCENE(s):
					if (s != null)
						if (s == VNState.instance?._issue)
							f(event);

				case SCENES(s):
					if (s != null)
						if (s.contains(VNState.instance?._issue))
							f(event);

				default:
			}
		}
	}

	public function continueLine()
		runOnEvents(event -> event.continueLine(this));

	public function onCreate()
		runOnEvents(event -> event.onCreate(this));

	public function onEnd(validEnd:Bool)
		runOnEvents(event -> event.onEnd(this, validEnd));

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		runOnEvents(event -> event.update(this, elapsed));
	}
}
