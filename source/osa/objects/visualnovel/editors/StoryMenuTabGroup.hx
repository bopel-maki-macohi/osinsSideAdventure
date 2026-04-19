package osa.objects.visualnovel.editors;

import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import osa.data.visualnovel.TaleData;

class StoryMenuTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var titleAssetInput:FlxUIInputText;
	public var onTitleAssetChangeCallback:String->Void;

	public var displayInput:FlxUIInputText;
	public var onDisplayTextChangeCallback:String->Void;

	public var filtersDropdown:FlxUIDropDownMenu;

	public var filterText:FlxUIInputText;
	public var onFilterAddedCallback:String->Void;

	override function create()
	{
		super.create();

        name = 'Story Menu';
	}
}
