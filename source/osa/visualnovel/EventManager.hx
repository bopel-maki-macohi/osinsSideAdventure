package osa.visualnovel;

import osa.visualnovel.events.*;
import flixel.group.FlxSpriteGroup;

class EventManager extends FlxSpriteGroup
{
	public function new()
	{
		super();
	}

	public var _currentEvent:String = null;

	public function build(event:String)
	{
		this._currentEvent = event;

		visible = true;
		if (event == null)
		{
			visible = false;
			return;
		}

		trace('Running event: $event');

		switch (event)
		{
			case 'testingEventSystem':
				TestingEventSystem.run(this);
			case 'chapter1Intro':
				Chapter1Intro.run(this);
		}
	}
}
