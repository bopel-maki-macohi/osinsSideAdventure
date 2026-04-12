package osa.visualnovel;

import osa.visualnovel.events.*;
import flixel.group.FlxSpriteGroup;

class EventManager extends FlxSpriteGroup
{
	public static var events:Map<String, EventRunner> = [
		'testingEventSystem' => new TestingEventSystem(NONE),
		'issue1Intro' => new Issue1Intro(),
		'issue1EstablishingShot' => new Issue1EstablishingShot(),
	];

	public function new()
	{
		super();
	}

	public var _currentEvent:String = null;

	public function runDialogueEvent(event:String):Bool
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
			events.get(event)?.runDialogueEvent(this);
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
						if (s == VNState.instance?._scene)
							f(event);

				default:
			}
		}
	}

	public function continueLine()
		runOnEvents(event -> event.continueLine(this));

	public function onCreate()
		runOnEvents(event -> event.onCreate(this));

	public function onEnd()
		runOnEvents(event -> event.onEnd(this));

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		runOnEvents(event -> event.update(this, elapsed));
	}
}
