package osa.states.visualnovel.events;

class Issue4 extends EventRunner
{
	override public function new()
	{
		super(SCENES(['issue 4']));
	}

	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

		_game.changeLine(1);
	}
}
