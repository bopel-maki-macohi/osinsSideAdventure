package flxnovel.objects.visualnovel.taleeditor;

import flxnovel.data.visualnovel.TaleData;
import flixel.addons.ui.FlxUITabMenu;

class TabMenu extends FlxUITabMenu implements ITaleContainer
{
	public var _tale:TaleData;

	public var dataTabGroup:DataTabGroup;
	public var linesTabGroup:LineTabGroup;
	public var storyTabGroup:StoryMenuTabGroup;

	override public function new(tale:TaleData)
	{
		super(null, null, [
			{name: 'Data', label: 'Data'},
			{name: 'Lines', label: 'Lines'},
			{name: 'Story Menu', label: 'Story Menu'},
		], true);

		resize(640, 480);

		setPosition(20, 20);
		screenCenter(Y);

		selected_tab = 0;

		dataTabGroup = new DataTabGroup(this);
		linesTabGroup = new LineTabGroup(this);
		storyTabGroup = new StoryMenuTabGroup(this);

		_tale = tale;

		addGroup(dataTabGroup);
		addGroup(linesTabGroup);
		addGroup(storyTabGroup);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		dataTabGroup._tale = linesTabGroup._tale = storyTabGroup._tale = _tale;
	}
}
