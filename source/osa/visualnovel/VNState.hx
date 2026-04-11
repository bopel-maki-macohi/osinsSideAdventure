package osa.visualnovel;

import lime.utils.Assets;
import flixel.FlxState;

class VNState extends FlxState
{
	public var _dialogueList:Array<String> = [];

	public var _dialogueEntry(default, set):Int = 0;

	function set__dialogueEntry(value:Int):Int
	{
        if (_dialogueList[value] == null)
            return _dialogueEntry;

        _dialogueLine._rawline =  _dialogueList[_dialogueEntry];
		return value;
	}

	public var _dialogueLine(default, null):DialogueLine = new DialogueLine(null);

	public function new(scene:String)
	{
		super();

		_dialogueList = scene.parseDialogueFile();
        _dialogueEntry = 0;

        trace('Dialogue List: ${_dialogueList}');
	}
}
