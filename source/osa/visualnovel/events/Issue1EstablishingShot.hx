package osa.visualnovel.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class Issue1EstablishingShot extends EventRunner
{
	override public function new()
	{
		super(NONE);
	}

	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

		FlxG.sound.play('prowler'.miscAsset().audioFile(), 1.0, false, null, true, function()
		{
			if (_game != null)
				_game.changeLine(1);
		});

		_game.changeLine(1);

		_game._dialogueBG.alpha = 0;

		FlxTween.tween(_game._dialogueBG, {alpha: 1}, (VNState.IN_LETTER_SPEED * LoremIpsum.piece.split(',')[0].length), {
			ease: FlxEase.sineInOut,
		});
	}
}
