package osa.states.visualnovel.events;

import osa.save.Save;
import flixel.util.FlxTimer;
import flixel.FlxG;

class Issue5 extends EventRunner
{
	override public function new()
	{
		super(ISSUES(['issue5']));
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		if (validEnd)
			Save.addIssue('issue6');
	}

	override function onBeatIssue(issue:String)
	{
		super.onBeatIssue(issue);

		if (issue == 'issue5')
			Save.addIssue('issue6');
	}
}
