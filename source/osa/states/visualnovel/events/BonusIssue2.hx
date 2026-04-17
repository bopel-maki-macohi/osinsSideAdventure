package osa.states.visualnovel.events;

import flixel.sound.FlxSound;

class BonusIssue2 extends IssueEventRunner
{
	public var crowdPanic:FlxSound;

	override public function new()
	{
		super(ISSUES(['bonusissue2']));
	}
}
