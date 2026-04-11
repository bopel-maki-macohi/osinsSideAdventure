package osa.menus;

import flixel.FlxG;
import flixel.sound.FlxSound;

class StoryMenuState extends OSAState
{
	public var _getYourAssUp:FlxSound;

	override function create()
	{
		_getYourAssUp = new FlxSound().loadEmbedded('updog/get-your-ass-up'.miscAsset().audioFile(), true);
		_getYourAssUp.fadeIn(this.transIn.duration);

		super.create();
	}

	override function onExit()
	{
		super.onExit();

		_getYourAssUp.fadeOut(this.transOut.duration);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new TitleState());
	}
}
