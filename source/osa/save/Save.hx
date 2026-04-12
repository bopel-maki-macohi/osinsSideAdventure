package osa.save;

import flixel.FlxG;

class Save
{
	public static var issues:SaveField<Array<String>>;

	public static var options:SaveField<SaveOptions>;

	static function fieldInit()
	{
		issues = new SaveField<Array<String>>('issues', []);
		options = new SaveField<SaveOptions>('options', {
			pcname: true,
			fpsCounter: true,
		});

		options.get().pcname ??= true;
		options.get().fpsCounter ??= true;

		addIssue('issue1');
		addIssue('issue2');
	}

	public static function addIssue(issuefile:String)
	{
		if (!issues.get().contains(issuefile))
			issues.get().push(issuefile);
	}

	public static function removeField(field:String)
	{
		if (Reflect.hasField(FlxG.save.data, field))
			Reflect.deleteField(FlxG.save.data, field);
	}

	public static function init()
	{
		FlxG.save.bind('OSA', 'Maki');

		removeField('chapters');

		fieldInit();

		FlxG.stage.application.onExit.add(function(l)
		{
			logSaveData();
			FlxG.save.flush();
		});

		logSaveData();
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
