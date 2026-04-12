package osa.visualnovel.events;

class SetDialogueSpeed extends EventRunner
{
	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

        _game._dialogueText.delay = Std.parseFloat(params[0] ?? '0.05');
		_game.changeLine(1);
	}
}

class ResetDialogueSpeed extends EventRunner
{
	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

        _game._dialogueText.delay = 0.05;
		_game.changeLine(1);
	}
}

class SetDialogueBoxHeightPadding extends EventRunner
{
	override function runDialogueEvent(eventManager:EventManager, ?params:Array<String>)
	{
		super.runDialogueEvent(eventManager, params);

        _game._dialogueBoxHeightPadding = Std.parseFloat(params[0] ?? '0');
		_game.changeLine(1);
	}
}
