package osa.states.menus;

import osa.objects.ClickableSprite;
import osa.save.Save;
import flixel.FlxG;

class OptionsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		addOption('pcname', () ->
		{
			return 'PC Name (${getEnabledString(Save.options.get().pcname)})'
				+ ' : Toggles if your pc name should / can be shown AT ALL.'
				+ '\n\nCurrently only used in the splash texts if you\'re curious as to why this is an option';
		}, () -> {
				#if !html5
				Save.options.get().pcname = !Save.options.get().pcname;
				#end
		});

		addOption('fpsCounter', () ->
		{
			return 'FPS Counter (${getEnabledString(Save.options.get().fpsCounter)})' + ' : Toggles the FPS Counter at the top left';
		}, () ->
			{
				Save.options.get().fpsCounter = !Save.options.get().fpsCounter;
				Main.FPSCounter.visible = Save.options.get().fpsCounter;
			});

		addOption('cache', () ->
		{
			return 'Asset Caching System (${getEnabledString(Save.options.get().cache)})' + ' : Toggles the Asset Caching System' + '\n\n(Resets the game)';
		}, () ->
			{
				Save.options.get().cache = !Save.options.get().cache;

				DebugSubState.resetGame();
			});
	}

	function addOption(assetName:String, gimmeStr:Void->String, gimmeAction:Void->Void, ?specialThing:ClickableSprite->Void)
	{
		var spr:ClickableSprite = makeSprite('options/$assetName', gimmeStr, gimmeAction);

		if (specialThing != null)
			specialThing(spr);

		_spriteList.push(spr);
	}

	public static function getEnabledString(value:Bool):String
		return value ? 'Enabled' : 'Disabled';
}
