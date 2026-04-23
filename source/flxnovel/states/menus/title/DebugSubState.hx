package flxnovel.states.menus.title;

import flxnovel.states.debug.BackgroundTesting;
import flxnovel.states.visualnovel.VNState;
import flxnovel.states.visualnovel.editors.TaleEditor;
import flxnovel.states.transition.SplashState;
import flixel.FlxG;
import flxnovel.save.Save;

class DebugSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		spriteList = [
			makeSprite('debug/default', () -> return 'Go to Tale Editor', () -> FlxG.switchState(() -> new TaleEditor())),

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
			makeSprite('debug/default', () -> return 'Go to Background Testing', () -> FlxG.switchState(() -> new BackgroundTesting())),
		];
	}

	public static function resetGame()
	{
		FlxG.resetGame();
	}
}
