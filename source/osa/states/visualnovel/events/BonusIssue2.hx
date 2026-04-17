package osa.states.visualnovel.events;

import flixel.sound.FlxSound;

class BonusIssue2 extends IssueEventRunner
{
	public var crowdPanic:FlxSound;

	override public function new()
	{
		super(ISSUES(['bonusissue2']));
	}

	override function onCreate(eventManager:EventManager)
	{
		super.onCreate(eventManager);

		crowdPanic = new FlxSound().loadEmbedded('sounds/crowd-panic'.visualNovelAsset().audioFile());

		crowdPanic.play();
		crowdPanic.pause();
	}

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		var playLines:Array<Int> = [1, 3, 5, 6, 11, 12, 13, 14];

		if (playLines.contains(_game._dialogueEntry))
		{
			crowdPanic.resume();
		}
		else
		{
			crowdPanic.pause();
		}
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		crowdPanic.destroy();
	}
}
