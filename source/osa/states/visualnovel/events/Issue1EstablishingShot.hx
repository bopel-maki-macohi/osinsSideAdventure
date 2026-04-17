package osa.states.visualnovel.events;

import osa.util.Constants;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class Issue1EstablishingShot extends IssueEventRunner
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

		FlxTween.tween(_game._dialogueBG, {alpha: 1}, (0.03 * Constants.LOREM_IPSUM.length), {
			ease: FlxEase.sineInOut,
			onUpdate: t ->
			{
				if (_game == null)
					t.cancel();
			}
		});
	}
}
