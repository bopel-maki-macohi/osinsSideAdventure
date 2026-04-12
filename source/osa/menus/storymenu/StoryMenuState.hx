package osa.menus.storymenu;

import osa.util.Constants;
import flixel.math.FlxMath;
import osa.objects.RhythmManager;
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

		_rhythmManager.reset();
		_rhythmManager._bpm = 110;

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

	override function destroy()
	{
		super.destroy();

		_rhythmManager.reset();
	}

	override function onBeatHit(curBeat:Int)
	{
		super.onBeatHit(curBeat);

		_issueIcon.scale.set(_issueIcon._baseScale * 1.1, _issueIcon._baseScale * 1.1);
		_issueTitle.scale.set(_issueTitle._baseScale * 1.1, _issueTitle._baseScale * 1.1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		_rhythmManager._time += elapsed * RhythmManager.MS_PER_SEC;

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(() -> new TitleState());

		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(() -> new VNState(_issueDialogueFile));

		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);

		_issueIcon.scale.x = FlxMath.lerp(_issueIcon.scale.x, _issueIcon._baseScale, Constants.DEFAULT_LERP_SPEED);
		_issueIcon.scale.y = FlxMath.lerp(_issueIcon.scale.y, _issueIcon._baseScale, Constants.DEFAULT_LERP_SPEED);

		_issueTitle.scale.x = FlxMath.lerp(_issueTitle.scale.x, _issueTitle._baseScale, Constants.DEFAULT_LERP_SPEED);
		_issueTitle.scale.y = FlxMath.lerp(_issueTitle.scale.y, _issueTitle._baseScale, Constants.DEFAULT_LERP_SPEED);
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

		_issueIcon.x -= _issueIcon.width;
		_issueTitle.x += _issueTitle.width;

		_issueDialogueFile = _issues[_currentSelection]._dialoguefile;
	}
}
