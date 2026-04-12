package osa.visualnovel.events;

import osa.util.Constants;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.filters.BlurFilter;
import flixel.FlxG;
import flixel.FlxCamera;

class Chapter1Script extends EventRunner
{
	public var _bgCam:FlxCamera;
	public var _tirokCam:FlxCamera;
	public var _osinCam:FlxCamera;
	public var _fgCam:FlxCamera;

	public var _blurFilterTirok:BlurFilter;
	public var _blurFilterOsin:BlurFilter;

	override function onCreate(eventManager:EventManager)
	{
		super.onCreate(eventManager);

		_bgCam = new FlxCamera();

		_fgCam = new FlxCamera();
		_fgCam.bgColor.alpha = 0;

		_tirokCam = new FlxCamera();
		_tirokCam.bgColor.alpha = 0;

		_osinCam = new FlxCamera();
		_osinCam.bgColor.alpha = 0;


		_blurFilterTirok = new BlurFilter(Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUS, 1);
		_blurFilterOsin = new BlurFilter(Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_UNFOCUS, 1);

		_tirokCam.filters = [_blurFilterTirok];
		_osinCam.filters = [_blurFilterOsin];

		game._dialogueBGGroup.camera = _bgCam;
		game._dialogueCharacterGroup.camera = _bgCam;
		game._dialogueBoxGroup.camera = _fgCam;
		game._dialogueFGGroup.camera = _fgCam;
		game._dialogueUIGroup.camera = _fgCam;

		FlxG.cameras.add(_bgCam, false);
		FlxG.cameras.add(_tirokCam, false);
		FlxG.cameras.add(_osinCam, false);
		FlxG.cameras.add(_fgCam);
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (_osinFocus)
		{
			_blurFilterOsin.blurX = FlxMath.lerp(_blurFilterOsin.blurX, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);
			_blurFilterOsin.blurY = FlxMath.lerp(_blurFilterOsin.blurY, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);

			_blurFilterTirok.blurX = FlxMath.lerp(_blurFilterTirok.blurX, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);
			_blurFilterTirok.blurY = FlxMath.lerp(_blurFilterTirok.blurY, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);
		}
		else
		{
			_blurFilterOsin.blurX = FlxMath.lerp(_blurFilterOsin.blurX, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);
			_blurFilterOsin.blurY = FlxMath.lerp(_blurFilterOsin.blurY, Constants.DEFAULT_BLUR_UNFOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);

			_blurFilterTirok.blurX = FlxMath.lerp(_blurFilterTirok.blurX, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);
			_blurFilterTirok.blurY = FlxMath.lerp(_blurFilterTirok.blurY, Constants.DEFAULT_BLUR_FOCUS, Constants.DEFAULT_BLUR_FOCUSCHANGE_SPEED);
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

		tirok.camera = _tirokCam;
		game._dialogueCharacter.camera = _osinCam;

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
