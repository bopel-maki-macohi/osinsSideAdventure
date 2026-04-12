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

	public var _issues:Array<StoryIssue> = [];

	public var _issueTitle:StoryIssueSprite;
	public var _issueIcon:StoryIssueSprite;
	public var _issueDialogueFile:String;

	override function create()
	{
		_getYourAssUp = new FlxSound().loadEmbedded('updog/get-your-ass-up'.miscAsset().audioFile(), true);
		_getYourAssUp.fadeIn(this.transIn.duration);

		for (issue in Save.issues.get())
			_issues.push(new StoryIssue('story/$issue'.menuAsset().textFile().readText()));

		_issueTitle = new StoryIssueSprite(false);
		_issueIcon = new StoryIssueSprite(true);

		add(_issueTitle);
		add(_issueIcon);

		_issueDialogueFile = '';

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
			FlxG.switchState(() -> new VNState(_issueDialogueFile));

		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);
	}

	function changeSelection(increment:Int)
	{
		_currentSelection += increment;

		if (_currentSelection < 0)
			_currentSelection = _issues.length - 1;
		if (_currentSelection > _issues.length - 1)
			_currentSelection = 0;

		_issueTitle.build(_issues[_currentSelection]._title);
		_issueIcon.build(_issues[_currentSelection]._icon);

		_issueIcon.x = _issueIcon.width * 2;
		_issueTitle.x = FlxG.width - (_issueTitle.width * 2);

		_issueDialogueFile = _issues[_currentSelection]._dialoguefile;
	}
}
