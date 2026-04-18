package osa.states.visualnovel.events;

import osa.save.Save;
import flixel.FlxG;

class Issue2EndSequence extends IssueEventRunner
{
	override public function new()
	{
		super(ISSUES(['issue2', 'issue2-', 'issue2-bonus']));
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (_game != null)
			if (!_game._leaving && FlxG.mouse.visible)
			{
				_game._dialogueCharacter.setColorTransform(1.0, 1.0, 1.0);

				if (FlxG.mouse.overlaps(_game._dialogueCharacter))
				{
					_game._dialogueCharacter.setColorTransform(1.5, 1.5, 1.5);

					if (FlxG.mouse.justPressed)
					{
						_game._dialogueCharacter.setColorTransform(1.0, 1.0, 1.0);
						_game._dialogueCharacter.build('chapter1/issue2/osin-glare-data', () -> _game.positionDialogueCharacter(_game._dialogueCharacter));

						_game._dialogueBG.build(null);

						_game.setDialogueSFX('default');
						_game._dialogueText.resetText('Issue 2 Secret unlocked.');
						_game._dialogueText.start(0.01);

						FlxG.mouse.visible = false;
					}
				}
			}
	}

	override function unlockIssues(issue:String)
	{
		super.unlockIssues(issue);

		if (_game?._dialogueCharacter?._id == 'chapter1/issue2/osin-glare-data' || issue == 'issue2-bonus')
		{
			Save.beatIssue('issue2-bonus');
			Save.addIssue('bonusissue1');
		}

		Save.addIssue('issue3');
	}

	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

		if (_game == null)
			return;

		FlxG.mouse.visible = true;

		_game.changeLine(1);
	}
}
