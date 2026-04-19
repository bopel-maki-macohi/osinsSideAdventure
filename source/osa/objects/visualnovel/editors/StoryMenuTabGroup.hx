package osa.objects.visualnovel.editors;

import osa.data.visualnovel.TaleData;

class StoryMenuTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	override function create()
	{
		super.create();

        name = 'Story Menu';
	}
}
