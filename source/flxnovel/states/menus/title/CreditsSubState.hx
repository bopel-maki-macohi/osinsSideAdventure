package flxnovel.states.menus.title;

import flixel.FlxG;

class CreditsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		spriteList = [
			makeSprite('credits/maki', () -> return 'Maki : Artist, Programmer', () -> FlxG.openURL('https://github.com/bopel-maki-macohi')),
			makeSprite('credits/requazar', () -> return 'Requazar : Composer, Motivator', () -> FlxG.openURL('https://www.youtube.com/@requazar')),
			makeSprite('credits/virtuguy', () -> return 'VirtuGuy : WTFEngine and it\'s conductor source code',
				() -> FlxG.openURL('https://github.com/VirtuGuy')),
		];
	}
}
