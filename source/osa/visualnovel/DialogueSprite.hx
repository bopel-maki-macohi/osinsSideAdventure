package osa.visualnovel;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class DialogueSprite extends FlxSprite
{
	public static final BACKGROUNDS_FOLDER:String = 'backgrounds';
	public static final CHARACTERS_FOLDER:String = 'characters';

	public var _isCharacter:Bool = false;

	override public function new(isCharacter)
	{
		super();

		this._isCharacter = isCharacter;
	}

	public var _id:String = 'null';

	public function build(id:String, ?onChange:Void->Void)
	{
		if (id == this._id)
			return;

		this._id = id;
		visible = true;

		if (id == null)
		{
			visible = false;
			return;
		}

		if (_isCharacter)
			loadGraphic('$CHARACTERS_FOLDER/$id'.visualNovelAsset().imageFile());
		else
		{
			switch (id)
			{
				case 'lightgrayvoid', 'lightgreyvoid':
					makeGraphic(FlxG.width, FlxG.height, 0xFFC0C0C0);

				case 'darkgrayvoid', 'darkgreyvoid':
					makeGraphic(FlxG.width, FlxG.height, 0xFF404040);

				case 'grayvoid', 'greyvoid':
					makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);

				case 'whitevoid':
					makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);

				case 'void', 'blackvoid':
					makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

				default:
					loadGraphic('$BACKGROUNDS_FOLDER/$id'.visualNovelAsset().imageFile());
			}
		}
		screenCenter();

		if (onChange != null)
			onChange();
	}

	override function toString():String
	{
		if (_isCharacter)
			return 'DialogueSprite(character : $_id)';

		return 'DialogueSprite(background : $_id)';
	}
}
