package osa.states.menus;

import osa.states.visualnovel.VNState;
import osa.states.transition.SplashState;
import flixel.FlxG;
import osa.save.Save;

class DebugSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		spriteList = [

			makeSprite('debug/default', () -> return 'Crash The Game', () -> throw 'DebugSubState Crash'),

			makeSprite('debug/default', () -> return 'Clear Save',
				() ->
				{
					FlxG.save.erase();

					Save.init();

					resetGame();
				}),
			makeSprite('debug/default', () -> return 'Log Save', () -> Save.logSaveData()),
			makeSprite('debug/default', () -> return 'Reset Game', resetGame),

			makeSprite('debug/default', () -> return 'Go to Splash', () -> FlxG.switchState(() -> new SplashState())),
			makeSprite('debug/default', () -> return 'Go to Github Page', () -> FlxG.openURL('https://github.com/bopel-maki-macohi/osinsSideAdventure')),
			makeSprite('debug/default', () -> return 'Go to Lorem Ipsum VN', () -> FlxG.switchState(() -> new VNState('lorem'))),
		];
	}

	public static function resetGame()
	{
		FlxG.resetGame();
	}
}
