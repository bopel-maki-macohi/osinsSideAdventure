package osa.objects.visualnovel.editors;

import openfl.net.FileFilter;
import openfl.net.FileReference;
import flixel.ui.FlxButton;
import osa.data.visualnovel.TaleData;

class DataTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var loadJSON:FlxButton;

	override function create()
	{
		super.create();

		name = 'Data';

		_fileReference = new FileReference();

		loadJSON = new FlxButton(10, 10, 'Load JSON', loadJSONMethod);
	}

	public var _fileReference:FileReference;

	function loadJSONMethod()
	{
		_fileReference.browse([new FileFilter('Data File', '.json')]);
	}
}
