package osa.visualnovel.events;

import osa.shaders.GrayscaleShader;
import osa.util.Constants;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.filters.BlurFilter;
import flixel.FlxG;
import flixel.FlxCamera;

class Chapter1Script extends EventRunner
{
	public var _tirokGrayscale:GrayscaleShader;
	public var _osinGrayscale:GrayscaleShader;

	override function onCreate(eventManager:EventManager)
	{
		super.onCreate(eventManager);

		_tirokGrayscale = new GrayscaleShader(1);
		_osinGrayscale = new GrayscaleShader(0);
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (_osinFocus)
		{
		}
		else
		{
		}
	}

	public var _osinFocus:Bool = false;

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		switch (game._dialogueEntry)
		{
			case 0, 1:
				_osinFocus = true;
			case 2:
				_osinFocus = false;
		}
	}

	override public function runDialogueEvent(eventManager:EventManager)
	{
		super.runDialogueEvent(eventManager);

		if (game._scene != 'chapter1')
			return;

		game.changeLine(1);

		var tirok:DialogueSprite = new DialogueSprite(true);
		tirok.build('chapter1/tirok-confused');

		tirok.x = game._dialogueBox.x + game._dialogueBox.width;

		game.positionDialogueCharacter(tirok, 0);
		game.positionDialogueCharacter(game._dialogueCharacter, 0);

		game._dialogueCharacterGroup.insert(0, tirok);

		FlxTween.tween(tirok, {x: game._dialogueBox.x}, 10, {
			ease: FlxEase.sineIn,
			onComplete: (t) ->
			{
				tirok.build('chapter1/tirok-OHSHIT');
				game.positionDialogueCharacter(tirok, 0);
				tirok.x = game._dialogueBox.x;

				game.changeLine(1);
			},
			onUpdate: (t) ->
			{
				game._dialogueTypingFinished = false;
				game._dialogueContinueHand.visible = false;
			}
		});
	}
}
