package flxnovel.states.menus;

import flxnovel.util.VersionUtil;
import flxnovel.util.Constants;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class OutdatedState extends FlxNovelState
{
	public var image:FlxSprite;

	public var text:FlxText;

	public static var SEEN:Bool = false;

	override function create()
	{
		super.create();

		OutdatedState.SEEN = true;

		image = new FlxSprite(0, 0, 'outdated'.imageFile().menuAsset());
		image.screenCenter();
		add(image);
		image.alpha = .1;

		text = new FlxText(0, 0, FlxG.width, '', 16);

		text.text = 'HEY THERE BUD!\n\n'
			+ 'Looks like you ain\'t runnin\' the latest version: ${VersionUtil.OUTDATED_LATEST_VERSION}!\n\n'
			+ 'You can press any of the following: ${controls.getKeyStrings(ACCEPT)} to go to the github and update.\n'
			+ 'Or you can additionally do it with any of the following: ${controls.getKeyStrings(SHIFT)} to go to the itch.io and update.\n\n'
			+ 'Or... you can miss out on some probably cool stuff by pressing any of the following: ${controls.getKeyStrings(LEAVE)} to play the current game.';
		text.alignment = CENTER;

		text.screenCenter();
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.justPressed.ACCEPT)
		{
			if (controls.pressed.SHIFT)
				FlxG.openURL('https://bopel-maki-macohi.itch.io/osins-side-adventure');
			else
				FlxG.openURL('https://github.com/bopel-maki-macohi/osinsSideAdventure/releases/latest');

			leave();
		}

		if (controls.justPressed.LEAVE)
			leave();
	}

	function leave()
	{
		FlxG.switchState(() -> new TitleState());
	}
}
