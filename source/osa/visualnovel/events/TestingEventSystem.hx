package osa.visualnovel.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TestingEventSystem extends EventRunner
{
	override function runDialogueEvent(eventManager:EventManager)
	{
		super.runDialogueEvent(eventManager);

		var char:DialogueSprite = new DialogueSprite(true);
		char.build('osin');
		eventManager.add(char);

		FlxTween.tween(char, {y: 10}, LoremIpsum.piece.split(',')[0].length * VNState.OUT_LETTER_SPEED, {
			ease: FlxEase.sineInOut,
			onComplete: t ->
			{
				_game.changeLine(1);
				FlxTween.tween(char, {alpha: 0}, _game._dialogueLine._line.length * VNState.OUT_LETTER_SPEED, {
					ease: FlxEase.sineInOut,
					onComplete: t ->
					{
						eventManager.remove(char);
						char.destroy();
					}
				});
			}
		});
	}
}
