package osa.states.visualnovel.events;

import flixel.util.FlxTimer;
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

		crowdPanic.onComplete = function() {
			// this'll be enough
			_game.changeLine(100);
		};
	}

	override function continueLine(eventManager:EventManager)
	{
		super.continueLine(eventManager);

		var playLines:Array<Int> = [1, 3, 5, 6, 11, 12, 13, 14];

		if (_game == null)
			return;

		if (playLines.contains(_game._dialogueEntry))
		{
			crowdPanic.resume();
		}
		else
		{
			crowdPanic.pause();
		}

		if (_game == null)
			return;

		if (_game._dialogueEntry < 12)
		{
			FlxTimer.wait(.1 + ((12 - _game._dialogueEntry) / 10), () ->
			{
				_game.changeLine(1);
			});
		}
	}

	override function onEnd(eventManager:EventManager, validEnd:Bool)
	{
		super.onEnd(eventManager, validEnd);

		crowdPanic.destroy();
	}

	override function update(eventManager:EventManager, elapsed:Float)
	{
		super.update(eventManager, elapsed);

		if (_game._dialogueEntry < 12)
			_game._dialogueTypingFinished = false;
	}
}
