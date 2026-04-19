package osa.objects.visualnovel.editors;

import osa.util.DateUtil;
import flixel.addons.ui.FlxUIInputText;
import json2object.JsonWriter;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.ui.FlxButton;
import osa.data.visualnovel.TaleData;

class DataTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var loadJSON:FlxButton;
	public var loadJSONCallback:FileReference->Void;

	public var saveJSON:FlxButton;
	public var saveJSONCallback:String->Void;

	public var taleID:FlxUIInputText;

	override function create()
	{
		super.create();

		name = 'Data';

		saveJSONCallback = e -> trace(e);

		loadJSON = new FlxButton(10, 10, 'Load JSON', loadJSONMethod);
		add(loadJSON);

		saveJSON = new FlxButton(loadJSON.x + loadJSON.width + 10, loadJSON.y, 'Save JSON', saveJSONMethod);
		add(saveJSON);

		taleID = new FlxUIInputText(loadJSON.x, loadJSON.y + loadJSON.height + 20, 620, '');
		add(makeText(taleID, 'Tale Name / ID'));
		add(taleID);
	}

	function saveJSONMethod()
	{
		var fileRef = new FileReference();

		fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
		fileRef.addEventListener(Event.CANCEL, onSaveCancel);
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

		fileRef.save(new JsonWriter<TaleData>().write(_tale, '\t'), '${(taleID.text.length > 0) ? taleID.text : 'VNEditor-${DateUtil.getTimestamp()}'}.json');
	}

	function onSaveComplete(e:Event)
	{
		trace('Successfully saved file');
		dispatchSaveJSONCallback('success');
	}

	function onSaveCancel(e:Event)
	{
		trace('Cancelled saving file');
		dispatchSaveJSONCallback('info');
	}

	function onSaveError(e:Event)
	{
		trace('IO error saving file');
		dispatchSaveJSONCallback('error');
	}

	function dispatchSaveJSONCallback(event:String)
	{
		if (saveJSONCallback != null)
			saveJSONCallback(event);
	}

	function loadJSONMethod()
	{
		var fileRef = new FileReference();

		fileRef.addEventListener(Event.SELECT, onLoadSelect);
		fileRef.browse();
	}

	function onLoadSelect(e:Event)
	{
		var fileRef:FileReference = e.target;

		trace('Selected file: ${fileRef.name}');

		fileRef.addEventListener(Event.COMPLETE, onLoadComplete);
		fileRef.load();
	}

	function onLoadComplete(e:Event)
	{
		var fileRef:FileReference = e.target;
		trace('Loaded file: ' + fileRef.name);

		if (loadJSONCallback != null)
			loadJSONCallback(fileRef);
	}
}
