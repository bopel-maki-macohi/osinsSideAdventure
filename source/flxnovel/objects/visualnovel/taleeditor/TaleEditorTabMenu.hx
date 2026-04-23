package flxnovel.objects.visualnovel.taleeditor;

import flxnovel.data.visualnovel.tales.ITaleContainer;
import flxnovel.data.visualnovel.TaleData;
import flixel.addons.ui.FlxUITabMenu;

class TaleEditorTabMenu extends FlxUITabMenu implements ITaleContainer
{
	public var _tale:TaleData;

	public var dataTabGroup:DataTabGroup;
	public var linesTabGroup:LineTabGroup;
	public var talesTabGroup:TalesMenuTabGroup;

	override public function new(tale:TaleData)
	{
		super(null, null, [
			{name: 'Data', label: 'Data'},
			{name: 'Lines', label: 'Lines'},
			{name: 'Tales Menu', label: 'Tales Menu'},
		], true);

		resize(640, 480);

		setPosition(10, 10);
		screenCenter(Y);

		selected_tab = 0;

		dataTabGroup = new DataTabGroup(this);
		linesTabGroup = new LineTabGroup(this);
		talesTabGroup = new TalesMenuTabGroup(this);

		_tale = tale;

		addGroup(dataTabGroup);
		addGroup(linesTabGroup);
		addGroup(talesTabGroup);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		dataTabGroup._tale = linesTabGroup._tale = talesTabGroup._tale = _tale;
	}
}
