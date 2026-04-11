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

		if (character == null)
		{
			return;
		}

		loadGraphic(character.characterFile().imageFile());
	}
}
