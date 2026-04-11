package osa.visualnovel;

import flixel.FlxSprite;

class DialogueCharacter extends FlxSprite
{
	override public function new()
	{
		super();
	}

	public var character:String = null;

	public function build(character:String)
	{
		this.character = character;

		if (character == null)
		{
			alpha = 0;
			return;
		}

		loadGraphic(character.characterFile().imageFile());
	}
}
