package osa.states.visualnovel.events.runners;

class IssueEventRunner extends EventRunner
{
	public function unlockIssues(issue:String) {}

	override function onBeatIssue(issue:String)
	{
		super.onBeatIssue(issue);

		switch (_dialogueFileType)
		{
			case ISSUE(i):
				if (issue == i)
					unlockIssues(issue);

			case ISSUES(iis):
				if (iis.contains(issue))
					unlockIssues(issue);

			default:
		}
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		if (validEnd)
			onBeatIssue(_game._issue);
	}
}
