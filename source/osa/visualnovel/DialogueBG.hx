package osa.visualnovel;

import flixel.FlxSprite;

class DialogueBG extends FlxSprite
{
	override public function new()
	{
		super();
	}

	public var background:String = null;

	public function build(background:String)
	{
		this.background = background;

		if (background == null)
		{
			alpha = 0;
			return;
		}

		loadGraphic(background.backgroundFile().imageFile());
	}
}
