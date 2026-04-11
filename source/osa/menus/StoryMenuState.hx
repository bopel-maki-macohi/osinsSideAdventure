package osa.menus;

import flixel.FlxG;
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

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new TitleState());
	}
}
