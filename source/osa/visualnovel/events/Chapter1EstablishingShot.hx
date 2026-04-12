package osa.visualnovel.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class Chapter1EstablishingShot extends EventRunner
{
	override public function new()
	{
		super(NONE);
	}

	override function runDialogueEvent(eventManager:EventManager)
	{
		super.runDialogueEvent(eventManager);

		FlxG.sound.play('prowler'.miscAsset().audioFile(), 1.0, false, null, true, function()
		{
			_game.changeLine(1);
		});

		_game.changeLine(1);

		_game._dialogueBG.alpha = 0;

		FlxTween.tween(_game._dialogueBG, {alpha: 1}, (VNState.IN_LETTER_SPEED * LoremIpsum.piece.split(',')[0].length), {
			ease: FlxEase.sineInOut,
		});
	}
}
