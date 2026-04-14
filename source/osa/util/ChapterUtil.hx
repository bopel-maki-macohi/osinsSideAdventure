package osa.util;

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

	public static function chapterFilter(chapterList:Array<String>, list:Array<String>):Array<String>
		return list.filter(f -> return chapterList.contains(f));

	public static function issueFilter(list:Array<String>):Array<String>
		return list.filter(f -> return f.startsWith('issue'));

	public static function bonusIssueFilter(list:Array<String>):Array<String>
		return list.filter(f -> return f.startsWith('bonusissue'));
}
