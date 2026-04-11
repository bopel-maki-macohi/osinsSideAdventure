package osa.visualnovel;

import flixel.FlxSprite;

class DialogueCharacter extends FlxSprite
{
	override public function new()
	{
		super();
	}

	public var _character:String = null;

	public function build(character:String)
	{
		this._character = character;
		alpha = 1;

		if (character == null)
		{
			alpha = 0;
			return;
		}

		loadGraphic(character.characterAsset().imageFile());
		screenCenter();
	}
}
