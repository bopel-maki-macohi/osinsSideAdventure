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

	override function create()
	{
		super.create();

		name = 'Story Menu';

		filtersDropdown = new FlxUIDropDownMenu(10, 20, null);
		add(makeText(filtersDropdown, 'Filters: '));
		add(filtersDropdown);

		titleAssetInput = new FlxUIInputText(filtersDropdown.x + filtersDropdown.width + 10, filtersDropdown.y, 620, '', 8);
		titleAssetInput.callback = onTitleAssetChange;

		add(makeText(titleAssetInput, 'Title Asset: '));
		add(titleAssetInput);

		displayInput = new FlxUIInputText(titleAssetInput.x, titleAssetInput.y + titleAssetInput.height + 20, Math.round(titleAssetInput.width), '', 8);
		displayInput.callback = onDisplayTextChange;

		add(makeText(displayInput, 'Title Asset: '));
		add(displayInput);
	}

	public function onTitleAssetChange(text:String, action:String)
	{
		if (onTitleAssetChangeCallback != null)
			onTitleAssetChangeCallback(text);
	}

	public function onDisplayTextChange(text:String, action:String)
	{
		if (onDisplayTextChangeCallback != null)
			onDisplayTextChangeCallback(text);
	}
}
