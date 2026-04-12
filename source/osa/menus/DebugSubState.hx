package osa.menus;

import osa.save.Save;

class DebugSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		_spriteList = [
			makeSprite('debug/default', () -> return 'Crash The Game', () -> throw 'DebugSubState Crash'),
			makeSprite('debug/default', () -> return 'Log Save', () -> Save.logSaveData()),
		];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
