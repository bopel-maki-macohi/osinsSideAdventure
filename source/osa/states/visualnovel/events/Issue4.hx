package osa.states.visualnovel.events;

import flixel.FlxG;

class Issue4 extends EventRunner
{
	override public function new()
	{
		super(SCENES(['issue4']));
	}

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		function contLine()
		{
			_game.changeLine(1);
		}

		switch (_game._dialogueEntry)
		{
			case 0:
				contLine();

			case 1, 2, 3:
				FlxG.sound.play('sounds/punch_${_game._dialogueEntry}'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 5, 6, 7:
				FlxG.sound.play('sounds/punch_${_game._dialogueEntry - 4}'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 8:
				FlxG.sound.play('sounds/Body_wall1'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			// case 11, 12:
		}
	}
}
