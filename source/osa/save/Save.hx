package osa.save;

import flixel.FlxG;

class Save
{
	public static var issues:SaveField<Array<String>>;

	static function fieldInit()
	{
		issues = new SaveField<Array<String>>('issues', ['issue1']);

		if (!issues.get().contains('issue1'))
			issues.get().push('issue1');
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
