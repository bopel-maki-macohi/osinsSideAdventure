package osa.visualnovel.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TestingEventSystem
{
	public static function run(eventManager:EventManager)
	{
		var char:DialogueSprite = new DialogueSprite(true);
		char.build('osin');
		eventManager.add(char);

		FlxTween.tween(char, {y: 10}, LoremIpsum.piece.split(',')[0].length * VNState.FADEOUT_LETTER_SPEED, {
			ease: FlxEase.sineInOut,
			onComplete: t ->
			{
				VNState.instance.changeLine(1);
				FlxTween.tween(char, {alpha: 0}, VNState.instance._dialogueLine._line.length * VNState.FADEOUT_LETTER_SPEED, {
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
