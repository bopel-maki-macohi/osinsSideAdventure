package osa.states.visualnovel.events;

import flixel.FlxG;
import osa.save.Save;

class Issue3EndingSequence extends IssueEventRunner
{
	override public function new()
	{
		super(ISSUES(['issue3']));
	}

	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

		_game.changeLine(1);
		FlxG.sound.play('sounds/thunderbolt-running'.visualNovelAsset().audioFile(), 1, false, null, true, function()
		{
			if (_game != null)
				_game.changeLine(1);
		});
	}

	override function unlockIssues(issue:String)
	{
		super.unlockIssues(issue);

		Save.addIssue('issue4');
	}
}
