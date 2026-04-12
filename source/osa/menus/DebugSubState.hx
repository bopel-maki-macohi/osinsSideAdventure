package osa.menus;

class DebugSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		_spriteList = [
			makeSprite('options/pcname', () -> return 'Crash The Game', () -> throw 'DebugSubState Crash'),
		];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
