package osa.objects.visualnovel.editors;

import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import flixel.ui.FlxButton;
import osa.data.visualnovel.TaleData;

class DataTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var loadJSON:FlxButton;
	public var loadJSONCallback:FileReference->Void;

	override function create()
	{
		super.create();

		name = 'Data';

		loadJSON = new FlxButton(10, 10, 'Load JSON', loadJSONMethod);
		add(loadJSON);
	}

	public var _fileReference:FileReference;

	function loadJSONMethod()
	{
		_fileReference = new FileReference();

		_fileReference.addEventListener(Event.SELECT, onLoadSelect);

		_fileReference.browse();
	}

	function clearFileReference()
	{
		_fileReference.removeEventListener(Event.SELECT, onLoadSelect);

		_fileReference = null;
	}

	function onLoadSelect(e:Event)
	{
		var file:FileReference = e.target;

		trace('Selected file: ${file.name}');

		file.addEventListener(Event.COMPLETE, onLoadComplete);
		file.load();
	}

	function onLoadComplete(e:Event)
	{
		var file:FileReference = e.target;
		trace('Loaded file: ' + file.name);

		if (loadJSONCallback != null)
			loadJSONCallback(file);
	}
}
