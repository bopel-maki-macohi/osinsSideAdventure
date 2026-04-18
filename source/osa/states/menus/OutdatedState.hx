package osa.states.menus;

import osa.util.VersionUtil;
import osa.util.Constants;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class OutdatedState extends OSAState
{
	public var _image:FlxSprite;

	public var _text:FlxText;

	public static var SEEN:Bool = false;

	override function create()
	{
		super.create();

		OutdatedState.SEEN = true;

		_image = new FlxSprite(0, 0, 'outdated'.imageFile().menuAsset());
		_image.screenCenter();
		add(_image);
		_image.alpha = .1;

		_text = new FlxText(0, 0, FlxG.width, '', 16);

		_text.text = 'HEY THERE BUD!\n\n'
			+ 'Looks like you ain\'t runnin\' the latest version: ${VersionUtil.OUTDATED_LATEST_VERSION}!\n\n'
			+ 'You can press any of the following: ${controls.getKeyStrings(ACCEPT)} to go to the github and update.\n'
			+ 'Or you can additionally do it with any of the following: ${controls.getKeyStrings(SHIFT)} to go to the itch.io and update.\n\n'
			+ 'Or... you can miss out on some probably cool stuff by pressing any of the following: ${controls.getKeyStrings(LEAVE)} to play the current game.';
		_text.alignment = CENTER;

		_text.screenCenter();
		add(_text);
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
