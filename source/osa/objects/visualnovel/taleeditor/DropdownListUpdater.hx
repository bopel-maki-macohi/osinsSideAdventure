package osa.objects.visualnovel.taleeditor;

import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.StrNameLabel;

class DropdownListUpdater
{
	public static function updateList(SMLList:Array<StrNameLabel>, btnList:Array<FlxUIButton>, dropdown:FlxUIDropDownMenu, startingValue:String, ?postUpdateList:Void->Void)
	{
		var diffs = 0;

		if (dropdown.list.length < btnList.length)
			diffs += btnList.length - dropdown.list.length;

		if (dropdown.list.length > btnList.length)
			diffs += btnList.length - dropdown.list.length;

		// trace(dropdown.list.length);
		// trace(btnList.length);

		if (btnList.length == 0 && dropdown.list.length > 0)
			diffs += dropdown.list.length;

		for (i => line in dropdown.list)
		{
			if (line?.label?.text != btnList[i]?.label?.text)
				diffs++;
		}

		if (Math.abs(diffs) > 0)
		{
			trace('Updated Dropdown(${dropdown.name}) ($diffs diffs)');

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
