package osa.save;

import flixel.FlxG;

class Save
{
	public static var issues:SaveField<Array<String>>;

	static function fieldInit()
	{
		issues = new SaveField<Array<String>>('issues', ['issue1']);

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
