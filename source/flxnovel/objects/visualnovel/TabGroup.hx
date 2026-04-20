package flxnovel.objects.visualnovel;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;

class TabGroup extends FlxUI
{
	public function new(tabMenu:FlxUITabMenu)
	{
		super(null, tabMenu);

		create();
	}

	public function create() {}

	public function makeText(parent:FlxSprite, text:String):FlxText
	{
		return new FlxText(parent.x, parent.y - 16, 0, text, 8);
	}
}
