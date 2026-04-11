package osa.visualnovel;

import flixel.addons.ui.FlxUIState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import lime.utils.Assets;
import flixel.FlxState;

class VNState extends OSAState
{
	public static final FADEOUT_LETTER_SPEED:Float = 0.1;

	public var _dialogueList:Array<String> = [];

	public var _dialogueEntry(default, set):Int = 0;

	function set__dialogueEntry(value:Int):Int
	{
		if (_dialogueList[value] == null)
		{
			trace('THERE IS NO DIALOGUE LINE AT $value');
			return _dialogueEntry;
		}

		_dialogueLine._rawline = _dialogueList[value];
		trace('Dialogue line at $value : $_dialogueLine');
		return _dialogueEntry = value;
	}

	public var _dialogueLine(default, null):DialogueLine = new DialogueLine(null);

	public function new(scene:String)
	{
		super();

		_dialogueList = scene.parseDialogueFile();

		trace('Dialogue List: ${_dialogueList}');
	}

	public var _dialogueBox:FlxSprite;
	public var _dialogueText:FlxTypeText;

	public var _dialogueContinueHand:FlxSprite;

	public var _dialogueCharacter:DialogueCharacter;
	public var _dialogueBG:DialogueBG;

	override function create()
	{
		super.create();

		_dialogueBox = new FlxSprite();
		_dialogueBox.makeGraphic(Math.round(FlxG.width * 0.9), Math.round(FlxG.height * 0.4));
		_dialogueBox.screenCenter();
		_dialogueBox.y = FlxG.height * 0.55;

		_dialogueText = new FlxTypeText(_dialogueBox.x, _dialogueBox.y, Math.round(_dialogueBox.width), LoremIpsum.piece, 16);
		_dialogueText.color = FlxColor.BLACK;

		_dialogueText.setTypingVariation(0.75, true);
		_dialogueText.skipKeys = ['SPACE'];
		_dialogueText.sounds = [
			FlxG.sound.load('type1'.dialogueAsset().audioFile()),
			FlxG.sound.load('type2'.dialogueAsset().audioFile()),
			FlxG.sound.load('type3'.dialogueAsset().audioFile()),
		];
		_dialogueText.finishSounds = true;

		_dialogueContinueHand = new FlxSprite(0, 0, 'continueHand'.dialogueAsset().imageFile());
		_dialogueContinueHand.scale.set(2, 2);
		_dialogueContinueHand.updateHitbox();

		_dialogueCharacter = new DialogueCharacter();

		_dialogueBG = new DialogueBG();

		add(_dialogueBG);
		add(_dialogueCharacter);
		add(_dialogueBox);
		add(_dialogueText);
		add(_dialogueContinueHand);

		changeLine(0);
	}

	public function getTextFadeTime():Float
		return _dialogueText.text.length * VNState.FADEOUT_LETTER_SPEED;

	public function changeLine(increment:Int)
	{
		if ((_dialogueEntry + increment) > (_dialogueList.length - 1))
		{
			for (object in [_dialogueBox, _dialogueContinueHand, _dialogueCharacter, _dialogueBG])
			{
				FlxTween.cancelTweensOf(object);
				FlxTween.tween(object, {alpha: 0}, getTextFadeTime());
			}

			_dialogueText.erase(VNState.FADEOUT_LETTER_SPEED, true, null, onEnd);
			return;
		}

		if ((_dialogueEntry + increment) < 0)
			return;

		_dialogueEntry += increment;

		_dialogueBox.visible = _dialogueLine._line != null;
		_dialogueText.visible = _dialogueBox.visible;

		resetText();

		buildBGAndCharacter();
	}

	function resetText()
	{
		_dialogueText.resetText(_dialogueLine?._line ?? '');
		_dialogueText.start(0.03, false, false, null, onDialogueFinishTyping);

		_dialogueTypingFinished = false;
		_dialogueContinueHand.visible = false;

		if (_dialogueLine._line == null)
			FlxTimer.wait(0.03 * LoremIpsum.piece.split(',')[0].length, onDialogueFinishTyping);
	}

	function buildBGAndCharacter()
	{
		_dialogueBG.build(_dialogueLine._bg);
		_dialogueCharacter.build(_dialogueLine._character);

		_dialogueCharacter.y = _dialogueBox.y + (_dialogueBox.height * 0.5) - _dialogueCharacter.height;
		if (!_dialogueBox.visible)
			_dialogueCharacter.y = FlxG.height - _dialogueCharacter.height;
	}

	public var _dialogueTypingFinished:Bool = false;

	public function onDialogueFinishTyping()
	{
		_dialogueTypingFinished = true;

		_dialogueContinueHand.visible = true;
		_dialogueContinueHand.setPosition(_dialogueBox.x
			+ _dialogueBox.width
			- _dialogueContinueHand.width,
			_dialogueBox.y
			+ _dialogueBox.height
			- _dialogueContinueHand.height);
	}

	public function onEnd()
	{
		trace('End');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_dialogueTypingFinished && FlxG.keys.justPressed.ENTER)
			changeLine(1);
	}
}
