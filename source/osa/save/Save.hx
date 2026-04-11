package osa.save;

import flixel.FlxG;

class Save
{
	public static var chapters:SaveField<Array<String>>;

	static function fieldInit()
	{
		chapters = new SaveField<Array<String>>('chapters', ['chapter1']);

		if (!chapters.get().contains('chapter1'))
			chapters.get().push('chapter1');
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
