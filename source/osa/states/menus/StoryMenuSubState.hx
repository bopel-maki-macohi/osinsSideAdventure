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

	public var _filters(get, never):Array<String>;

	function get__filters():Array<String>
	{
		var filters:Array<String> = ['all'];

		if (Save.issues.get().filter(f -> return f.startsWith('issue')).length > 0)
			filters.push('issues');

		if (Save.issues.get().filter(f -> return f.startsWith('bonusissue')).length > 0)
			filters.push('bonus');

		if (Save.issues.get().filter(f -> return !Save.beatissues.get().contains(f)).length > 0)
			filters.push('unplayed');

		for (chapterFilter => chapterList in ChapterUtil.CHAPTER_MAP)
		{
			/**
			 * A chapter1 filtered
			 * [issue10,issue9,issue1,issue2]
			 * 
			 * would end up
			 * [issue1,issue2,issue10,issue9]
			 */
			if (ChapterUtil.chapterFilter(chapterList, Save.issues.get()) != Save.issues.get())
				filters.push(chapterFilter.replace(' ', '').toLowerCase());
		}

		return filters;
	}

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

			case 'unplayed':
				filterList = filterList.filter(f -> return !Save.beatissues.get().contains(f));

			case 'all', null:

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

		_addDefaultScaleThingies = false;
		createSprites();
	}

	override function nonScrollingControls()
	{
		super.nonScrollingControls();

		if (FlxG.keys.anyJustPressed([W, S, UP, DOWN]))
		{
			var filters = _filters;

			if (FlxG.keys.anyJustPressed([W, UP]))
				reload(filters[filters.indexOf(_currentFilter) + 1] ?? filters[0]);
			if (FlxG.keys.anyJustPressed([S, DOWN]))
				reload(filters[filters.indexOf(_currentFilter) - 1] ?? filters[filters.length - 1]);

			Constants.selectSfx();
		}
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
			if (Save.beatissues.get().contains(issue))
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.RED;
		});
		spr._unoverlapUpdate.add(function()
		{
			if (Save.beatissues.get().contains(issue))
				spr.color = FlxColor.WHITE;
			else
				spr.color = FlxColor.PINK;
		});

		return spr;
	}

	function issueMsg(issue:String)
	{
		var msg:String = '';

		msg += 'Filter: ${_currentFilter.toUpperCase()}\n';
		msg += 'Issue Chapter: ${ChapterUtil.getChapter(issue)}\n';
		msg += 'Percent Complete: ${ChapterUtil.getChapterPercentComplete(issue)}%';

		if (!Save.beatissues.get().contains(issue))
			msg += '\n(NEW / HAVEN\'T PLAYED IT)';

		return msg;
	}

	function onEnter()
	{
		FlxG.sound.music.fadeOut(OSAState.DEFAULT_TRANSITION.duration);
		FlxG.switchState(() -> VNState.build(_issueDialogueFile));
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
			final scale = 0.5 + ((1 * (((FlxG.sound.muted) ? 0 : FlxG.sound.volume) / 1)) / 10);

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
