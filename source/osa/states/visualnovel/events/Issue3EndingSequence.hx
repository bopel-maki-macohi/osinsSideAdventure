package osa.states.visualnovel.events;

import osa.save.Save;

class Issue3EndingSequence extends EventRunner
{
	override public function new()
	{
		super(SCENES(['issue3']));
	}

	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		if (validEnd)
			Save.addIssue('issue4');
	}
}
