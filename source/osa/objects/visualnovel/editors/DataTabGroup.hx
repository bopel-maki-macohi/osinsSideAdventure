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
	public var loadJSONCallback:String->Void;

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

		_fileReference.addEventListener(Event.COMPLETE, onLoadComplete);
		_fileReference.addEventListener(Event.CANCEL, onLoadCancel);
		_fileReference.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		_fileReference.browse([new FileFilter('Data File', '.json')]);
	}

	function removeFileReferenceEvents()
	{
		_fileReference.removeEventListener(Event.COMPLETE, onLoadComplete);
		_fileReference.removeEventListener(Event.CANCEL, onLoadCancel);
		_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
	}

	function onLoadComplete(e:Event)
	{
		removeFileReferenceEvents();

		trace('Load Complete: ' + e);

		if (loadJSONCallback != null)
			loadJSONCallback('');
	}

	function onLoadCancel(e:Event)
	{
		removeFileReferenceEvents();

		trace('Load Cancel: ' + e);
	}

	function onLoadError(e:Event)
	{
		removeFileReferenceEvents();
		
		trace('Load Error: ' + e);
	}
}
