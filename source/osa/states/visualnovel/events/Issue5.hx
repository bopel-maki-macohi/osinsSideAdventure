package osa.states.visualnovel.events;

import flixel.FlxG;
import osa.save.Save;

class Issue5 extends IssueEventRunner
{
	override public function new()
	{
		super(ISSUES(['issue5', 'issue5-bonus']));
	}

	override function unlockIssues(issue:String)
	{
		super.unlockIssues(issue);

		if (_game?._dialogueCharacter?._id == 'chapter1/issue2/osin-glare-data' || issue == 'issue5-bonus')
		{
			Save.beatIssue('issue5-bonus');
			Save.addIssue('bonusissue2');
		}
		else
			Save.addIssue('issue6');
	}

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		if (_game._dialogueEntry == 19)
		{
			FlxG.mouse.visible = true;
		}
		else
		{
			FlxG.mouse.visible = false;
		}
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
						for (line in _game._dialogueList.filter(f -> return _game._dialogueList.indexOf(f) > _game._dialogueEntry))
							_game._dialogueList.remove(line);

						_game._dialogueCharacter.setColorTransform(1.0, 1.0, 1.0);
						_game._dialogueCharacter.build('chapter1/issue2/osin-glare-data', () -> _game.positionDialogueCharacter(_game._dialogueCharacter));

						_game._dialogueBG.build(null);

						_game.setDialogueSFX('default');

						_game._dialogueText.delay = 0.1;
						_game._dialogueText.resetText('Issue 5 Secret unlocked.');
						_game._dialogueText.start(0.01);

						FlxG.mouse.visible = false;
					}
				}
			}
	}
}
