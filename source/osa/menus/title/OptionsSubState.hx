package osa.menus.title;

import flixel.FlxG;

class OptionsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		_spriteList = [
			makeSprite('credits/maki', () -> return 'Maki : Artist, Programmer', () -> FlxG.openURL('https://github.com/bopel-maki-macohi')),
			makeSprite('credits/pogo', () -> return 'Pogo : VS IMPOSTOR (Updog) - Get Your Ass Up! (Temp song for story menu)',
				() -> FlxG.openURL('https://www.youtube.com/watch?v=aDTAem9_Yws')),
			makeSprite('credits/virtuguy', () -> return 'VirtuGuy : WTFEngine and it\'s conductor source code',
				() -> FlxG.openURL('https://github.com/VirtuGuy'))
		];
	}
}
