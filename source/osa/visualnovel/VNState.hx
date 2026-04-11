package osa.visualnovel;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import lime.utils.Assets;
import flixel.FlxState;

class VNState extends FlxState
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
		trace('Dialogue line at $value');
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

	override function create()
	{
		super.create();

		_dialogueBox = new FlxSprite();
		_dialogueBox.makeGraphic(Math.round(FlxG.width * 0.9), Math.round(FlxG.height * 0.4));
		_dialogueBox.screenCenter();
		_dialogueBox.y = FlxG.height * 0.55;

		_dialogueText = new FlxTypeText(_dialogueBox.x, _dialogueBox.y, Math.round(_dialogueBox.width), 'Lorem Ipsum Dolar Sit Amet', 16);
		// _dialogueText.setBorderStyle(SHADOW, FlxColor.BLACK);
		_dialogueText.color = FlxColor.BLACK;

		_dialogueText.setTypingVariation(0.75, true);

		_dialogueText.skipKeys = ['SPACE'];

		add(_dialogueBox);
		add(_dialogueText);

		changeLine(0);
	}

	public function changeLine(increment:Int)
	{
		if ((_dialogueEntry + increment) > (_dialogueList.length - 1))
		{
			FlxTween.tween(_dialogueBox, {alpha: 0}, _dialogueText.text.length * VNState.FADEOUT_LETTER_SPEED);
			_dialogueText.erase(VNState.FADEOUT_LETTER_SPEED, true, null, () ->
			{
				onEnd();
			});
			return;
		}

		if ((_dialogueEntry + increment) < 0)
			return;

		_dialogueEntry += increment;

		_dialogueBox.visible = _dialogueLine._line != null;
		_dialogueText.visible = _dialogueBox.visible;

		_dialogueText.resetText(_dialogueLine?._line ?? '');
		_dialogueText.start(0.03);
	}

	public function onEnd()
	{
		trace('End');
	}
}
