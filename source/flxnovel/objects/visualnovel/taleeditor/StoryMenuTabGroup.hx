package flxnovel.objects.visualnovel.taleeditor;

import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.StrNameLabel;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flxnovel.data.visualnovel.TaleData;

class StoryMenuTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var titleAssetInput:FlxUIInputText;
	public var onTitleAssetChangeCallback:String->Void;

	public var displayInput:FlxUIInputText;
	public var onDisplayTextChangeCallback:String->Void;

	public var filtersDropdown:FlxUIDropDownMenu;

	public var filterInput:FlxUIInputText;

	public var addFilterBTN:FlxButton;
	public var onAddFilterCallback:String->Void;

	public var removeFilterBTN:FlxButton;
	public var onRemoveFilterCallback:String->Void;

	override function create()
	{
		super.create();

		name = 'Story Menu';

		filtersDropdown = new FlxUIDropDownMenu(10, 20, null);
		add(makeText(filtersDropdown, 'Filters: '));
		add(filtersDropdown);
		filtersDropdown.name = 'Filters';

		titleAssetInput = new FlxUIInputText(filtersDropdown.x + filtersDropdown.width + 10, filtersDropdown.y, 480, '', 8);
		titleAssetInput.callback = onTitleAssetChange;

		add(makeText(titleAssetInput, 'Title Asset: '));
		add(titleAssetInput);

		displayInput = new FlxUIInputText(titleAssetInput.x, titleAssetInput.y + titleAssetInput.height + 20, Math.round(titleAssetInput.width), '', 8);
		displayInput.callback = onDisplayTextChange;

		add(makeText(displayInput, 'Display Text: '));
		add(displayInput);

		filterInput = new FlxUIInputText(displayInput.x, displayInput.y + displayInput.height + 20, Math.round(titleAssetInput.width), '', 8);

		add(makeText(filterInput, 'Target Filter: '));
		add(filterInput);

		addFilterBTN = new FlxButton(filterInput.x, filterInput.y + filterInput.height + 10, 'Add Filter', onAddFilter);
		add(addFilterBTN);

		removeFilterBTN = new FlxButton(addFilterBTN.x + addFilterBTN.width + 10, addFilterBTN.y, 'Remove Filter', onRemoveFilter);
		add(removeFilterBTN);
	}

	public function onAddFilter()
	{
		if (onAddFilterCallback != null)
			onAddFilterCallback(filterInput.text.toLowerCase().trim());
	}

	public function onRemoveFilter()
	{
		if (onRemoveFilterCallback != null)
			onRemoveFilterCallback(filterInput.text.toLowerCase().trim());
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

	public var filters(get, never):Array<StrNameLabel>;

	function get_filters():Array<StrNameLabel>
	{
		return [for (i => filter in _tale?.storymenu?.filters ?? []) new StrNameLabel('$i', filter)];
	}

	public var btnFilters(get, never):Array<FlxUIButton>;

	function get_btnFilters():Array<FlxUIButton>
	{
		@:privateAccess
		return [for (i => line in filters) filtersDropdown.makeListButton(i, line.label, line.name)];
	}

	public function updateList()
	{
		DropdownListUpdater.updateList(filters, btnFilters, filtersDropdown, '0');

		updateAll();
	}

	public function updateAll()
	{
		titleAssetInput.text = _tale?.storymenu?.titleAsset ?? '';
		displayInput.text = _tale?.storymenu?.display ?? '';
	}
}
