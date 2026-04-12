package osa.visualnovel.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class Chapter1Intro
{
	public static function run(eventManager:EventManager)
	{
		VNState.instance.changeLine(1);

        var tirok:DialogueSprite = new DialogueSprite(true);
		tirok.build('chapter1/tirok-confused');

		tirok.x = VNState.instance._dialogueBox.x + VNState.instance._dialogueBox.width;

		VNState.instance.positionDialogueCharacter(tirok, 0);
		VNState.instance.positionDialogueCharacter(VNState.instance._dialogueCharacter, 0);

		VNState.instance.insert(VNState.instance.members.indexOf(VNState.instance._dialogueCharacter), tirok);
		FlxTween.tween(tirok, {x: VNState.instance._dialogueBox.x}, 10, {
			ease: FlxEase.sineIn,
			onUpdate: (t) ->
			{
				VNState.instance._dialogueTypingFinished = false;
                VNState.instance._dialogueContinueHand.visible = false;
			}
		});
	}
}
