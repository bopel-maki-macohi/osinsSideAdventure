package osa.objects.visualnovel.editors;

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
}
