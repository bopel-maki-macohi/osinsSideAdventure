package flxnovel.util;

import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.StrNameLabel;

class DropdownListUpdater
{
	public static function updateList(SMLList:Array<StrNameLabel>, btnList:Array<FlxUIButton>, dropdown:FlxUIDropDownMenu, startingValue:String,
			?postUpdateList:Void->Void)
	{
		var diffs = Math.abs(btnList.length - dropdown.list.length);

		for (i => button in btnList)
		{
			if (dropdown?.list[i]?.name != button?.name)
				diffs += 1;
		}

		if (diffs != 0)
		{
			trace('Updated Dropdown(${dropdown.name}) ($diffs diffs (length & name))');

			if (SMLList.length == 0)
			{
				for (button in dropdown.list)
				{
					dropdown.list.remove(button);
					button.destroy();
				}
				dropdown.selectedId = startingValue;
				dropdown.header.text.text = '';

				@:privateAccess {
					dropdown.dropPanel.resize(dropdown.header.background.width, dropdown.getPanelHeight());
					dropdown.updateButtonPositions();
				}
			}
			else
				dropdown.setData(SMLList);

			if (postUpdateList != null)
				postUpdateList();
		}
	}
}
