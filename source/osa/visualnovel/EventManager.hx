package osa.visualnovel;

import flixel.FlxSprite;
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
	}
}
