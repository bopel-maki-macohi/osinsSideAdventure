package osa.menus;

import flixel.FlxG;
import osa.save.Save;

class DebugSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		_spriteList = [
			makeSprite('debug/default', () -> return 'Crash The Game', () -> throw 'DebugSubState Crash'),
			makeSprite('debug/default', () -> return 'Log Save', () -> Save.logSaveData()),
			makeSprite('debug/default', () -> return 'Reset Game', () -> FlxG.resetGame()),
			makeSprite('debug/default', () -> return 'Go to Splash', () -> FlxG.switchState(() -> new InitState())),
			makeSprite('debug/default', () -> return 'Go to Github Page', () -> FlxG.openURL('https://github.com/bopel-maki-macohi/osinsSideAdventure')),
		];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
