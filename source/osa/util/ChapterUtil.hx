package osa.util;

import flixel.math.FlxMath;
import osa.save.Save;
import osa.states.visualnovel.EventManager;

class ChapterUtil
{
	public static final CHAPTER_ONE:Array<String> = [
		'issue1',
		'issue2',
		'issue3',
		'issue4',
		'issue5',
		'issue6',
		'bonusissue1',
		'bonusissue2',
	];

	public static inline function chapterFilter(chapterList:Array<String>, list:Array<String>):Array<String>
		return list.filter(f -> return chapterList.contains(f));

	public static inline function issueFilter(list:Array<String>):Array<String>
		return list.filter(f -> return f.startsWith('issue'));

	public static inline function bonusIssueFilter(list:Array<String>):Array<String>
		return list.filter(f -> return f.startsWith('bonusissue'));

	public static inline function getChapter(issue:String):String
	{
		if (CHAPTER_ONE.contains(issue))
			return 'Chapter 1';

		return 'Unknown';
	}

	public static inline function getChapterPercentComplete(issue:String):Float
	{
		var n:Int = 0;
		var d:Int = 1;

		if (Save.beatissues.get().contains(issue))
			n++;

		switch (issue)
		{
			case 'issue2':
				if (Save.beatissues.get().contains('issue2-bonus'))
					n++;
				d++;
		}

		return FlxMath.roundDecimal((n / d) * 100, 2);
	}
}
