package osa.menus;

import flixel.sound.FlxSound;

class StoryMenuState extends OSAState
{
	public var getYourAssUp:FlxSound;

	override function create()
	{
		getYourAssUp = new FlxSound().loadEmbedded('updog/get-your-ass-up'.miscAsset().audioFile(), true);
		getYourAssUp.fadeIn(this.transIn.duration);

		super.create();
	}

	override function onExit()
	{
		super.onExit();

		getYourAssUp.fadeOut(this.transOut.duration);
	}
}
