package osa.save;

import flixel.FlxG;

class Save
{
	public static var issues:SaveField<Array<String>>;

	public static var options:SaveField<SaveOptions>;

	static function fieldInit()
	{
		issues = new SaveField<Array<String>>('issues', ['issue1']);
		options = new SaveField<SaveOptions>('options', {
			pcname: true,
		});

		options.get().pcname ??= true;

		addIssue('issue1');
	}

	public static function addIssue(issuefile:String)
	{
		if (!issues.get().contains(issuefile))
			issues.get().push(issuefile);
	}

	public static function init()
	{
		FlxG.save.bind('OSA', 'Maki');

		fieldInit();

		FlxG.stage.application.onExit.add(function(l)
		{
			FlxG.save.flush();
		});

		trace('Save: ${FlxG.save.data}');
	}
}
