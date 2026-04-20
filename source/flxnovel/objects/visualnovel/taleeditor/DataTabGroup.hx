package flxnovel.objects.visualnovel.taleeditor;

import flxnovel.data.visualnovel.tales.ITaleContainer;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.io.Path;
import flxnovel.util.DateUtil;
import flixel.addons.ui.FlxUIInputText;
import json2object.JsonWriter;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.ui.FlxButton;
import flxnovel.data.visualnovel.TaleData;

class DataTabGroup extends TabGroup implements ITaleContainer
{
	public var _tale:TaleData;

	public var _taleID:String = '';
	public var lockedInTaleID:Bool = false;
	public var taleIDUpdateTimer:FlxTimer;

	public var loadJSON:FlxButton;
	public var loadJSONCallback:FileReference->Void;

	public var saveJSON:FlxButton;
	public var saveJSONPreCallback:Void->Void;
	public var saveJSONPostCallback:Void->Void;

	public var taleIDInput:FlxUIInputText;
	public var taleIDPreviewText:FlxText;

	override function create()
	{
		super.create();

		name = 'Data';

		loadJSON = new FlxButton(10, 10, 'Load JSON', loadJSONMethod);
		add(loadJSON);

		saveJSON = new FlxButton(loadJSON.x + loadJSON.width + 10, loadJSON.y, 'Save JSON', saveJSONMethod);
		add(saveJSON);

		taleIDInput = new FlxUIInputText(loadJSON.x, loadJSON.y + loadJSON.height + 20, 620, '');
		taleIDInput.callback = onTaleIDUpdate;
		add(makeText(taleIDInput, 'Tale Name / ID'));
		add(taleIDInput);

		taleIDPreviewText = new FlxText(taleIDInput.x, taleIDInput.y, taleIDInput.width, '', taleIDInput.size);
		taleIDPreviewText.color = FlxColor.GRAY;
		add(taleIDPreviewText);

		taleIDUpdateTimer = new FlxTimer();
		taleIDUpdateTimer.start(1, t ->
		{
			if (!lockedInTaleID)
				setDummyTaleID();
		}, 0);

		setDummyTaleID();
	}

	public function setDummyTaleID()
	{
		_taleID = 'VNEditor-${DateUtil.getTimestamp()}';

		taleIDPreviewText.text = _taleID;
	}

	function onTaleIDUpdate(text:String, action:String)
	{
		_taleID = text.trim();

		lockedInTaleID = (_taleID.length > 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		taleIDPreviewText.visible = !lockedInTaleID;
	}

	function saveJSONMethod()
	{
		if (saveJSONPreCallback != null)
			saveJSONPreCallback();

		var fileRef = new FileReference();

		fileRef.addEventListener(Event.SELECT, onSaveComplete);
		fileRef.addEventListener(Event.CANCEL, onSaveCancel);
		fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

		fileRef.save(new JsonWriter<TaleData>().write(_tale, '\t'), '$_taleID.json');
	}

	function onSaveComplete(e:Event)
	{
		trace('Successfully saved file');

		_taleID = Path.withoutExtension(e.target.name);
		lockedInTaleID = true;
		taleIDInput.text = _taleID;

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

		_taleID = Path.withoutExtension(e.target.name);
		lockedInTaleID = true;
		taleIDInput.text = _taleID;

		if (loadJSONCallback != null)
			loadJSONCallback(fileRef);
	}
}
