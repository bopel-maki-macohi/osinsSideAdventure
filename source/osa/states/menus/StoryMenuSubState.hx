package osa.states.menus;

import flixel.util.FlxColor;
import osa.util.ChapterUtil;
import osa.states.transition.VNCacher;
import osa.util.Constants;
import flixel.math.FlxMath;
import osa.save.Save;
import osa.states.visualnovel.VNState;
import osa.objects.ClickableSprite;
import osa.objects.RhythmManager;
import flixel.FlxG;
import flixel.sound.FlxSound;

class StoryMenuSubState extends TitleSubStateBase
{
	public var _issues:Array<String> = [];
	public var _issueDialogueFile:String;

	public static var filters:Array<String> = ['all', 'issues', 'bonus', 'chapter1',];

	public var _currentFilter:String = null;

	function reload(?filter:String)
	{
		if (_currentFilter == filter)
			return;
		_currentFilter = filter;

		_currentSelection = 0;
		_sprites.setPosition();

		Save.sortIssues();

		_issues = [];
		_spriteList = [];

		if (_sprites != null)
			_sprites.clear();

		var filterList:Array<String> = Save.issues.get();

		switch (filter?.toLowerCase()?.trim())
		{
			case 'chapter1':
				filterList = ChapterUtil.chapterFilter(ChapterUtil.CHAPTER_ONE, filterList);

			case 'bonus':
				filterList = ChapterUtil.bonusIssueFilter(filterList);

			case 'issues':
				filterList = ChapterUtil.issueFilter(filterList);

			case 'all':

			case null:

			default:
				trace('Unimplemented filter: ${filter.toLowerCase().trim()}');
		}

		for (issue in filterList)
		{
			var parsed:Array<String> = issue.parseDialogueFile();

			if (parsed.length < 1)
				continue;

			_issues.push(issue);
			_spriteList.push(makeIssueSprite(issue));
		}

		createSprites();
	}

	override function nonScrollingControls()
	{
		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);

		final filters = StoryMenuSubState.filters;

		if (FlxG.keys.anyJustPressed([W, UP]))
			reload(filters[filters.indexOf(_currentFilter) - 1] ?? filters[filters.length - 1]);
		if (FlxG.keys.anyJustPressed([S, DOWN]))
			reload(filters[filters.indexOf(_currentFilter) + 1] ?? filters[0]);
	}

	override function create()
	{
		super.create();

		FlxG.sound.playMusic('updog/get-your-ass-up'.miscAsset().audioFile());
		FlxG.sound.music.fadeIn(OSAState.DEFAULT_TRANSITION.duration);

		_rhythmManager.reset();
		_rhythmManager._bpm = 110;

		onBeatHit(0);

		_text.size = 24;
		_text.borderSize = 3;

		_text.fieldWidth = FlxG.width;
		_text.alignment = CENTER;

		reload('all');
	}

	function makeIssueSprite(issue:String):ClickableSprite
	{
		var spr:ClickableSprite = makeSprite('story/$issue', () -> issueMsg(issue), function()
		{
			onEnter();
		});

		spr._overlapUpdate.add(function()
		{
			spr.color = FlxColor.YELLOW;
		});
		spr._unoverlapUpdate.add(function()
		{
			spr.color = FlxColor.WHITE;
		});

		return spr;
	}

	function issueMsg(issue:String)
	{
		var msg:String = '';

		msg += 'Filter: ${_currentFilter.toUpperCase()}\n';
		msg += 'Issue Chapter: ${ChapterUtil.getChapter(issue)}';

		return msg;
	}

	function onEnter()
	{
		FlxG.sound.music.fadeOut(OSAState.DEFAULT_TRANSITION.duration);
		FlxG.switchState(() -> new VNCacher(new VNState(_issueDialogueFile), false, _issueDialogueFile));
	}

	override function close()
	{
		FlxG.sound.music.fadeOut(OSAState.DEFAULT_TRANSITION.duration);

		super.close();
	}

	override function destroy()
	{
		super.destroy();

		_rhythmManager.reset();
	}

	override function onBeatHit(curBeat:Int)
	{
		super.onBeatHit(curBeat);

		for (sprite in _sprites.members)
		{
			final scale = 0.6;

			sprite.scale.set(scale, scale);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		_rhythmManager._time += elapsed * RhythmManager.MS_PER_SEC;

		for (sprite in _sprites.members)
		{
			final scale = FlxMath.lerp(sprite.scale.x, 0.5, Constants.DEFAULT_LERP_SPEED);

			sprite.scale.set(scale, scale);
		}

		_text.y = 32;
	}

	override function changeSelection(increment:Int)
	{
		super.changeSelection(increment);

		_issueDialogueFile = _issues[_currentSelection];
	}
}
