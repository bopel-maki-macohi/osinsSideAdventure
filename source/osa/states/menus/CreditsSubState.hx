package osa.states.menus;

import flixel.FlxG;

class CreditsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		spriteList = [
			makeSprite('credits/maki', () -> return 'Maki : Artist, Programmer', () -> FlxG.openURL('https://github.com/bopel-maki-macohi')),
			makeSprite('credits/requazar', () -> return 'Requazar : Composer, Motivator', () -> FlxG.openURL('https://www.youtube.com/@requazar')),
			makeSprite('credits/pogo', () -> return 'Pogo : VS IMPOSTOR (Updog) - Get Your Ass Up! (Temp song for story menu)',
				() -> FlxG.openURL('https://www.youtube.com/watch?v=aDTAem9_Yws')),
			makeSprite('credits/virtuguy', () -> return 'VirtuGuy : WTFEngine and it\'s conductor source code',
				() -> FlxG.openURL('https://github.com/VirtuGuy')),
		];
	}
}
