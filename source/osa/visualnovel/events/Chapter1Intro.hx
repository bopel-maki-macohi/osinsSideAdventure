package osa.visualnovel.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class Chapter1Intro extends EventRunner
{
	override public function run(eventManager:EventManager)
	{
		super.run(eventManager);

		game.changeLine(1);

		var tirok:DialogueSprite = new DialogueSprite(true);
		tirok.build('chapter1/tirok-confused');

		tirok.x = game._dialogueBox.x + game._dialogueBox.width;

		game.positionDialogueCharacter(tirok, 0);
		game.positionDialogueCharacter(game._dialogueCharacter, 0);

		game.insert(game.members.indexOf(game._dialogueCharacter), tirok);
		FlxTween.tween(tirok, {x: game._dialogueBox.x}, 10, {
			ease: FlxEase.sineIn,
			onUpdate: (t) ->
			{
				game._dialogueTypingFinished = false;
				game._dialogueContinueHand.visible = false;
			}
		});
	}
}
