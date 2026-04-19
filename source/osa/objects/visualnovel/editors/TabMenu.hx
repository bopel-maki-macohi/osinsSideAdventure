package osa.objects.visualnovel.editors;

import flixel.addons.ui.FlxUITabMenu;

class TabMenu extends FlxUITabMenu
{
	public var linesTabGroup:LineTabGroup;
	public var storyTabGroup:StoryMenuTabGroup;

	override public function new()
	{
		super(null, null, [{name: 'Lines', label: 'Lines'}, {name: 'Story Menu', label: 'Story Menu'},], true);

		resize(640, 480);

		setPosition(20, 20);
		screenCenter(Y);

		selected_tab = 0;

		linesTabGroup = new LineTabGroup(this);
		storyTabGroup = new StoryMenuTabGroup(this);

		addGroup(linesTabGroup);
		addGroup(storyTabGroup);
	}
}
