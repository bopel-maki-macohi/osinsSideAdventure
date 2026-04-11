package osa.visualnovel;

import flixel.FlxG;
import flixel.FlxSprite;
import lime.utils.Assets;
import flixel.FlxState;

class VNState extends FlxState
{
	public var _dialogueList:Array<String> = [];

	public var _dialogueEntry(default, set):Int = 0;

	function set__dialogueEntry(value:Int):Int
	{
		if (_dialogueList[value] == null)
		{
			trace('THERE IS NO DIALOGUE LINE AT $value');
			return _dialogueEntry;
		}

		_dialogueLine._rawline = _dialogueList[_dialogueEntry];
		return value;
	}

	public var _dialogueLine(default, null):DialogueLine = new DialogueLine(null);

	public function new(scene:String)
	{
		super();

		_dialogueList = scene.parseDialogueFile();

		trace('Dialogue List: ${_dialogueList}');
	}

	public var _dialogueBox:FlxSprite;

	override function create()
	{
		super.create();

		_dialogueBox = new FlxSprite();
		_dialogueBox.makeGraphic(Math.round(FlxG.width * 0.9), Math.round(FlxG.height * 0.4));
		_dialogueBox.screenCenter();
		_dialogueBox.y = FlxG.height * 0.55;

		add(_dialogueBox);

		changeLine(0);
	}

	public function changeLine(increment:Int)
	{
		if (_dialogueEntry + increment > _dialogueList.length - 1)
		{
			onEnd();
			return;
		}

		if (_dialogueEntry + increment < 0)
			return;

		_dialogueEntry += increment;

		_dialogueBox.visible = _dialogueLine._line != null;
	}

	public function onEnd() {}
}
