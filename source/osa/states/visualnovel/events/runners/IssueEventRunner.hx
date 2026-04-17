package osa.states.visualnovel.events.runners;

import osa.states.visualnovel.events.runners.EventRunner.EventRunnerDialogueFile;

class IssueEventRunner extends EventRunner
{
	public var _issuesToUnlock:Void->Void;

	override public function new(dialogueFileType:EventRunnerDialogueFile, ?issuesToUnlock:Void->Void)
	{
		super(dialogueFileType);

		this._issuesToUnlock = issuesToUnlock;
	}

	override function onBeatIssue(issue:String)
	{
		super.onBeatIssue(issue);

		if (_issuesToUnlock != null)
			_issuesToUnlock();
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		if (validEnd && _issuesToUnlock != null)
			_issuesToUnlock();
	}
}
