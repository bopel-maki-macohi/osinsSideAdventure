package osa.states.visualnovel.events;

import osa.save.Save;
import flixel.FlxG;

class Issue2EndSequence extends EventRunner
{
	override public function new()
	{
		super(SCENES(['issue2', 'issue2-']));
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (FlxG.mouse.visible && _game._dialogueCharacter._id == 'issue2/osin-glare')
		{
			_game._dialogueCharacter.setColorTransform(1.0, 1.0, 1.0);

			if (FlxG.mouse.overlaps(_game._dialogueCharacter))
			{
				_game._dialogueCharacter.setColorTransform(1.5, 1.5, 1.5);

				if (FlxG.mouse.justPressed)
				{
					_game._dialogueCharacter.setColorTransform(1.0, 1.0, 1.0);
					_game._dialogueCharacter.build('issue2/osin-glare-data', () -> _game.positionDialogueCharacter(_game._dialogueCharacter));

					_game._dialogueText.resetText('ACCESS GRANTED.');
					_game._dialogueText.start(0.01);
				}
			}
		}
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		if (validEnd)
		{
			if (_game._dialogueCharacter._id == 'issue2/osin-glare-data')
				Save.addIssue('bonusissue1');

			Save.addIssue('issue3');
		}
	}

	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

		FlxG.mouse.visible = true;

		_game.changeLine(1);
	}
}
