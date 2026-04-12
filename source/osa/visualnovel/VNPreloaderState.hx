package osa.visualnovel;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class VNPreloaderState extends OSAState
{
	public var _vnState:FlxState;
	public var _issue:String;

	override public function new(vnState:FlxState, issue:String)
	{
		super();

		this._vnState = vnState;
		this._issue = issue;
	}

	public var _text:FlxText;

	override function create()
	{
		super.create();

		_text = new FlxText(0, 0, 0, 'Preloading Issue:\n$_issue', 32);
		_text.alignment = CENTER;
		_text.screenCenter();
		add(_text);

		performPreload();
	}

	public function performPreload()
	{
		var chars:Array<String> = [];
		var bgs:Array<String> = [];

		for (rawline in _issue.parseDialogueFile())
		{
			var dialogueLine:DialogueLine = new DialogueLine(rawline);

			if (dialogueLine._isEvent)
				continue;

			final char = dialogueLine._character;
			final bg = dialogueLine._bg;

			final charPath = '${DialogueSprite.CHARACTERS_FOLDER}/$char'.visualNovelAsset().imageFile();
			final bgPath = '${DialogueSprite.BACKGROUNDS_FOLDER}/$bg'.visualNovelAsset().imageFile();

			if (char != null)
				if (charPath.fileExists() && !chars.contains(charPath))
					chars.push(charPath);

			if (bg != null)
				if (bgPath.fileExists() && !bgs.contains(bgPath))
					bgs.push(bgPath);
		}

		for (charPath in chars)
			FlxG.bitmap.add(charPath, false, null);
	}
}
