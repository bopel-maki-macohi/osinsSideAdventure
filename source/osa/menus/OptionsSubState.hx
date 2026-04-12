package osa.menus;

import osa.save.Save;
import flixel.FlxG;

class OptionsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		_spriteList = [
			makeSprite('options/pcname', function()
			{
				return
					'PC Name (${getEnabledString(Save.options.get().pcname)}) : Toggles if your pc name should / can be shown AT ALL.\n\nCurrently only used in the splash texts if you\'re curious as to why this is an option';
			}, function()
			{
				Save.options.get().pcname = !Save.options.get().pcname;
			}),
		];
	}

	public static function getEnabledString(value:Bool):String
		return value ? 'Enabled' : 'Disabled';
}
