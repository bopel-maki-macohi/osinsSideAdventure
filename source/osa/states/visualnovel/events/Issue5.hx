package osa.states.visualnovel.events;

import osa.save.Save;

class Issue5 extends IssueEventRunner
{
	override public function new()
	{
		super(ISSUES(['issue5']));
	}

	override function unlockIssues(issue:String)
	{
		super.unlockIssues(issue);

		Save.addIssue('issue6');
	}
}
