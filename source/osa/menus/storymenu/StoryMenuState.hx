package osa.menus.storymenu;

import osa.visualnovel.VNState;
import flixel.FlxSprite;
import osa.save.Save;
import flixel.FlxG;
import flixel.sound.FlxSound;

class StoryMenuState extends OSAState
{
	public var _getYourAssUp:FlxSound;

	public var _currentSelection:Int = 0;

	public var _chapters:Array<StoryChapter> = [];

	public var _chapterTitle:StoryChapterSprite;
	public var _chapterIcon:StoryChapterSprite;
	public var _chapterDialogueFile:String;

	override function create()
	{
		_getYourAssUp = new FlxSound().loadEmbedded('updog/get-your-ass-up'.miscAsset().audioFile(), true);
		_getYourAssUp.fadeIn(this.transIn.duration);

		for (chapter in Save.chapters.get())
			_chapters.push(new StoryChapter('story/$chapter'.menuAsset().textFile().readText()));

		_chapterTitle = new StoryChapterSprite(false);
		_chapterIcon = new StoryChapterSprite(true);

		add(_chapterTitle);
		add(_chapterIcon);

		_chapterDialogueFile = '';

		super.create();

		changeSelection(0);
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

		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(() -> new VNState(_chapterDialogueFile));

		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);
	}

	function changeSelection(increment:Int)
	{
		_currentSelection += increment;

		if (_currentSelection < 0)
			_currentSelection = _chapters.length - 1;
		if (_currentSelection > _chapters.length - 1)
			_currentSelection = 0;

		_chapterTitle.build(_chapters[_currentSelection]._title);
		_chapterIcon.build(_chapters[_currentSelection]._icon);

		_chapterIcon.y = 10;
		_chapterTitle.y = FlxG.height - (_chapterTitle.height * 1.1);

		_chapterDialogueFile = _chapters[_currentSelection]._dialoguefile;
	}
}
