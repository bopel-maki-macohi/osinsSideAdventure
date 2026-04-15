package osa.states.visualnovel.events;

import flixel.FlxG;
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

		_game.changeLine(1);
		FlxG.sound.play('sounds/thunderbolt-running'.visualNovelAsset().audioFile(), 1, false, null, true, function()
		{
			_game.changeLine(1);
		});
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		if (validEnd)
			Save.addIssue('issue4');
	}
}
