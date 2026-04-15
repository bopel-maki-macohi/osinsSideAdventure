package osa.states.visualnovel.events;

import osa.util.Constants;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TestingEventSystem extends EventRunner
{
	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

		var char:DialogueSprite = new DialogueSprite(true);
		char.build('osin');
		eventManager.add(char);

		FlxTween.tween(char, {y: 10}, Constants.LOREM_IPSUM.length * VNState.OUT_LETTER_SPEED, {
			ease: FlxEase.sineInOut,
			onComplete: t ->
			{
				if (_game != null)
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
			},
			onUpdate: t ->
			{
				if (_game == null)
					t.cancel();
			}
		});
	}
}
