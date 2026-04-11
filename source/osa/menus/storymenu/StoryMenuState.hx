package osa.menus.storymenu;

import osa.save.Save;
import flixel.FlxG;
import flixel.sound.FlxSound;

class StoryMenuState extends OSAState
{
	public var _getYourAssUp:FlxSound;

	public var _currentSelection:Int = 0;

	public var _chapters:Array<StoryChapter> = [];

	override function create()
	{
		_getYourAssUp = new FlxSound().loadEmbedded('updog/get-your-ass-up'.miscAsset().audioFile(), true);
		_getYourAssUp.fadeIn(this.transIn.duration);

		for (chapter in Save.chapters.get())
			_chapters.push(new StoryChapter('story/$chapter'.menuAsset().textFile().readText()));

		super.create();
	}

	override function onExit()
	{
		super.onExit();

		_getYourAssUp.fadeOut(this.transOut.duration);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new TitleState());

		if (FlxG.keys.anyJustPressed([A, LEFT]))
			_currentSelection--;
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			_currentSelection++;

		if (_currentSelection < 0)
			_currentSelection = _chapters.length - 1;
		if (_currentSelection > _chapters.length - 1)
			_currentSelection = 0;
	}
}
