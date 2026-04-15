package osa.save;

import osa.states.visualnovel.EventManager;
import osa.util.SortUtil;
import flixel.FlxG;

class Save
{
	public static var issues:SaveField<Array<String>>;
	public static var beatissues:SaveField<Array<String>>;

	public static var options:SaveField<SaveOptions>;

	static function fieldInit()
	{
		issues = new SaveField<Array<String>>('issues', []);
		options = new SaveField<SaveOptions>('options', {
			pcname: true,
			fpsCounter: true,
			cache: true,
		});
		beatissues = new SaveField<Array<String>>('beatissues', ['issue1']);

		options.get().pcname ??= true;
		#if html5
		options.get().pcname = false;
		#end

		options.get().fpsCounter ??= true;
		options.get().cache ??= true;

		#if LOSE_EVERYTHING
		issues.set([]);
		#end

		addIssue('issue1');
		addIssue('issue2');

		beatIssue('issue1');

		#if UNLOCK_EVERYTHING
		for (issue in ISSUE_ORDER_PREFERENCE)
		{
			addIssue(issue);
			beatIssue(issue);
		}
		beatIssue('issue2-bonus');
		#end

		for (issue in beatissues.get())
			EventManager.onBeatIssue(issue);

		Main.FPSCounter.visible = options.get().fpsCounter;
	}

	public static final ISSUE_ORDER_PREFERENCE:Array<String> = ['issue1', 'issue2', 'bonusissue1', 'issue3', 'issue4',];

	public static function addIssue(issuefile:String)
	{
		if (!issues.get().contains(issuefile))
			issues.get().push(issuefile);

		sortIssues();
	}

	public static function beatIssue(id:String)
	{
		if (!beatissues.get().contains(id))
			beatissues.get().push(id);
	}

	public static function sortIssues()
	{
		issues.get().sort((a, b) -> SortUtil.defaultsAlphabetically(ISSUE_ORDER_PREFERENCE, a, b));
	}

	public static function removeField(field:String)
	{
		if (Reflect.hasField(FlxG.save.data, field))
			Reflect.deleteField(FlxG.save.data, field);
	}

	public static function init()
	{
		FlxG.save.bind('OSA', 'Maki');

		removeField('chapters');

		fieldInit();

		FlxG.stage.application.onExit.add(function(l)
		{
			trace(FlxG.save.data);
			FlxG.save.flush();
		});

		trace(FlxG.save.data);
	}

	public static function logSaveData()
	{
		#if sys
		Sys.println(saveDataLog());
		#else
		trace(saveDataLog());
		#end
	}

	public static function saveDataLog()
	{
		var data:String = 'Save:\n';

		for (field in Reflect.fields(FlxG.save.data))
			data += '$field : ${Reflect.field(FlxG.save.data, field)}\n';

		return data;
	}
}
