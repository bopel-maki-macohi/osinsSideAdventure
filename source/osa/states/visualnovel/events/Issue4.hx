package osa.states.visualnovel.events;

import flixel.util.FlxTimer;
import flixel.FlxG;

class Issue4 extends EventRunner
{
	override public function new()
	{
		super(ISSUES(['issue4']));
	}

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		function contLine()
		{
			if (_game != null)
				_game.changeLine(1);
		}

		switch (_game._dialogueEntry)
		{
			case 0:
				contLine();

			case 1, 2, 3:
				FlxG.sound.play('sounds/punch_${_game._dialogueEntry}'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 4, 9, 10:
				FlxTimer.wait(_game._dialogueLine._line.length * _game._dialogueText.delay + .25, contLine);

			case 5, 6, 7:
				FlxG.sound.play('sounds/punch_${_game._dialogueEntry - 4}'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 8:
				FlxG.sound.play('sounds/Body_wall1'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 11, 12:
				FlxTimer.wait('????'.length * _game._dialogueText.delay, contLine);

			case 13:
				FlxG.sound.play('sounds/whoosh type4 05'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 14, 15:
				FlxG.sound.play('sounds/loroc-flyingSfx'.visualNovelAsset().audioFile(), 1, false, null, true, contLine);

			case 16:
				_game.setDialogueSFX('loroc');
		}
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (_game != null)
			if (_game._dialogueEntry != 16)
				_game._dialogueTypingFinished = false;
	}
}
