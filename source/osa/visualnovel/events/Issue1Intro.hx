package osa.visualnovel.events;

import flixel.util.FlxTimer;
import osa.shaders.GrayscaleShader;
import osa.util.Constants;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.filters.BlurFilter;
import flixel.FlxG;
import flixel.FlxCamera;

class Issue1Intro extends EventRunner
{
	override public function new()
	{
		super(SCENE('issue1'));
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (_game._dialogueEntry > 4)
			return;

		if (_osinFocus)
		{
			_game._dialogueCharacter.alpha = FlxMath.lerp(_game._dialogueCharacter.alpha, 1, Constants.DEFAULT_LERP_SPEED);
			_tirok.alpha = FlxMath.lerp(_tirok.alpha, 0.4, Constants.DEFAULT_LERP_SPEED);
		}
		else
		{
			_game._dialogueCharacter.alpha = FlxMath.lerp(_game._dialogueCharacter.alpha, 0.4, Constants.DEFAULT_LERP_SPEED);
			_tirok.alpha = FlxMath.lerp(_tirok.alpha, 1, Constants.DEFAULT_LERP_SPEED);
		}
	}

	public var _osinFocus:Bool = false;

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		switch (_game._dialogueEntry)
		{
			case 0, 1:
				_osinFocus = true;
			case 2:
				_osinFocus = false;
			case 3:
				_osinFocus = true;
				FlxTimer.wait(VNState.OUT_LETTER_SPEED * (_game._dialogueLine._line.length / 2), () ->
				{
					_game.changeLine(1);
				});
			case 4:
				_game._dialogueCharacter.alpha = 1;
				_game._dialogueCharacterGroup.remove(_tirok);
		}
	}

	public var _tirok:DialogueSprite = new DialogueSprite(true);

	override public function runDialogueEvent(eventManager:EventManager)
	{
		super.runDialogueEvent(eventManager);

		if (_game._scene != 'issue1')
			return;

		_game.changeLine(1);

		_tirok.build('issue1/tirok-confused');

		_tirok.x = _game._dialogueBox.x + _game._dialogueBox.width;

		_game.positionDialogueCharacter(_tirok);
		_game.positionDialogueCharacter(_game._dialogueCharacter);

		_game._dialogueCharacterGroup.insert(0, _tirok);

		FlxTween.tween(_tirok, {x: _game._dialogueBox.x}, 10, {
			ease: FlxEase.sineIn,
			onComplete: (t) ->
			{
				_tirok.build('issue1/tirok-OHSHIT', () ->
				{
					_game.positionDialogueCharacter(_tirok);
					_tirok.x = _game._dialogueBox.x;
				});

				_game.changeLine(1);
			},
			onUpdate: (t) ->
			{
				_game._dialogueTypingFinished = false;
			}
		});
	}
}
