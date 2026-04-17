package osa.util;

import flixel.math.FlxMath;
import osa.save.Save;

class ChapterUtil
{
	public static final ISSUE_ORDER_PREFERENCE:Array<String> = [
		'issue1',
		'issue2',
		'bonusissue1',
		'issue3',
		'issue4',
		'issue5',
		'bonusissue2',
		'issue6'
	];

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

	public static final CHAPTER_MAP:Map<String, Array<String>> = ['Chapter 1' => CHAPTER_ONE,];

	public static inline function chapterFilter(chapterList:Array<String>, list:Array<String>):Array<String>
		return list.filter(f -> return chapterList.contains(f));

	public static inline function issueFilter(list:Array<String>):Array<String>
		return list.filter(f -> return f.startsWith('issue'));

	public static inline function bonusIssueFilter(list:Array<String>):Array<String>
		return list.filter(f -> return f.startsWith('bonusissue'));

	public static function getChapter(issue:String):String
	{
		for (name => chapter in CHAPTER_MAP)
			if (chapter.contains(issue))
				return name;

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
