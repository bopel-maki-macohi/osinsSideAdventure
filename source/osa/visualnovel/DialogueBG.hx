package osa.visualnovel;

import flixel.FlxSprite;

class DialogueBG extends FlxSprite
{
	override public function new()
	{
		super();
	}

	public var _background:String = null;

	public function build(background:String)
	{
		this._background = background;

		if (background == null)
		{
			return;
		}

		loadGraphic(background.backgroundFile().imageFile());
	}
}
