package osa.states.visualnovel.events.runners;

class IssueEventRunner extends EventRunner
{
	public function unlockIssues(issue:String) {}

	override function onBeatIssue(issue:String)
	{
		super.onBeatIssue(issue);

		switch (_dialogueFileType)
		{
			case ISSUE(issue):
				if (_game._issue == issue)
					unlockIssues(issue);

			case ISSUES(issues):
				if (issues.contains(_game._issue))
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
