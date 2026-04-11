package osa.visualnovel;

import flixel.FlxSprite;

class DialogueSprite extends FlxSprite
{
	public var _isCharacter:Bool = false;

	override public function new(isCharacter)
	{
		super();

		this._isCharacter = isCharacter;
	}

	public var _id:String = null;

	public function build(id:String)
	{
		this._id = id;
		alpha = 1;

		if (id == null)
		{
			alpha = 0;
			return;
		}

		if (_isCharacter)
			loadGraphic('characters/$id'.visualNovelAsset().imageFile());
		else
			loadGraphic('backgrounds/$id'.visualNovelAsset().imageFile());
		screenCenter();
	}

	override function toString():String
	{
		if (_isCharacter)
			return 'DialogueSprite(character : $_id)';

		return 'DialogueSprite(background : $_id)';
	}
}
