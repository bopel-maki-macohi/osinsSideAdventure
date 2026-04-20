package flxnovel.save;

import flixel.FlxG;

class Save
{
	public static var issues:SaveField<Array<String>>;
	public static var beatissues:SaveField<Array<String>>;

	public static var options:SaveField<SaveOptions>;

	static function fieldInit()
	{
		issues = new SaveField<Array<String>>('issues', []);
		options = new SaveField<SaveOptions>('options', {
			pcname: true,
			debugDisplay: true,
		});
		beatissues = new SaveField<Array<String>>('beatissues', []);

		options.get().pcname ??= true;
		#if html5
		options.get().pcname = false;
		#end

		options.get().debugDisplay ??= (options.get().fpsCounter ?? true);

		Main.debugDisplay.visible = options.get().debugDisplay;

		removeField('chapters');

		removeField('issues');
		removeField('beatissues');
	}

	public static function removeField(field:String)
	{
		if (Reflect.hasField(FlxG.save.data, field))
			Reflect.deleteField(FlxG.save.data, field);
	}

	public static function init()
	{
		FlxG.save.bind('OSA', 'Maki');

		fieldInit();

		FlxG.stage.application.onExit.add(function(l)
		{
			trace(FlxG.save.data);
			FlxG.save.flush();
		});

		trace(FlxG.save.data);
	}

	public static function logSaveData()
	{
		#if sys
		Sys.println(saveDataLog());
		#else
		trace(saveDataLog());
		#end
	}

	public static function saveDataLog()
	{
		var data:String = 'Save:\n';

		for (field in Reflect.fields(FlxG.save.data))
			data += '$field : ${Reflect.field(FlxG.save.data, field)}\n';

		return data;
	}
}
