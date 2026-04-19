package osa.objects.visualnovel.taleeditor;

import haxe.io.Path;
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
	public var saveJSONPreCallback:Void->Void;
	public var saveJSONPostCallback:Void->Void;

	public var taleID:FlxUIInputText;

	override function create()
	{
		super.create();

		name = 'Data';

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
		if (saveJSONPreCallback != null)
			saveJSONPreCallback();

		var fileRef = new FileReference();

		fileRef.addEventListener(Event.SELECT, onSaveComplete);
		fileRef.addEventListener(Event.CANCEL, onSaveCancel);
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

		var filename:String = taleID.text;

		if (taleID.text.length < 1)
		{
			filename = 'VNEditor-${DateUtil.getTimestamp()}';
			taleID.text = filename;
		}

		fileRef.save(new JsonWriter<TaleData>().write(_tale, '\t'), '$filename.json');
	}

	function onSaveComplete(e:Event)
	{
		trace('Successfully saved file');

		taleID.text = Path.withoutExtension(e.target.name);

		dispatchSaveJSONCallback();
	}

	function onSaveCancel(e:Event)
	{
		trace('Cancelled saving file');
		dispatchSaveJSONCallback();
	}

	function onSaveError(e:Event)
	{
		trace('IO error saving file');
		dispatchSaveJSONCallback();
	}

	function dispatchSaveJSONCallback()
	{
		if (saveJSONPostCallback != null)
			saveJSONPostCallback();
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

		taleID.text = Path.withoutExtension(e.target.name);
		
		if (loadJSONCallback != null)
			loadJSONCallback(fileRef);
	}
}
