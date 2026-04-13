package osa.states.menus;

import osa.save.Save;
import flixel.FlxG;

class OptionsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		addOption('pcname', function()
		{
			return
				'PC Name (${getEnabledString(Save.options.get().pcname)}) : Toggles if your pc name should / can be shown AT ALL.\n\nCurrently only used in the splash texts if you\'re curious as to why this is an option';
		}, function()
		{
			Save.options.get().pcname = !Save.options.get().pcname;
		});

		addOption('fpsCounter', function()
		{
			return 'FPS Counter (${getEnabledString(Save.options.get().fpsCounter)}) : Toggles the FPS Counter at the top left';
		}, function()
		{
			Save.options.get().fpsCounter = !Save.options.get().fpsCounter;
			Main.FPSCounter.visible = Save.options.get().fpsCounter;
		});

		addOption('cache', function()
		{
			return 'Asset Caching System (${getEnabledString(Save.options.get().cache)}) : Toggles the Asset Caching System\n\n(Resets the game)';
		}, function()
		{
			Save.options.get().cache = !Save.options.get().cache;

			DebugSubState.resetGame();
		});
	}

	function addOption(assetName:String, gimmeStr:Void->String, gimmeAction:Void->Void)
	{
		_spriteList.push(makeSprite('options/$assetName', gimmeStr, gimmeAction));
	}

	public static function getEnabledString(value:Bool):String
		return value ? 'Enabled' : 'Disabled';
}
