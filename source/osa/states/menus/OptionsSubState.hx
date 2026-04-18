package osa.states.menus;

import osa.objects.ClickableSprite;
import osa.save.Save;

class OptionsSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		addOption('pcname', () ->
		{
			var msg:String = 'PC Name (${getEnabledString(Save.options.get().pcname)})'
				+ ' : Toggles if your pc name should / can be shown AT ALL.'
				+ '\n\nCurrently only used in the splash texts if you\'re curious as to why this is an option';

			#if html5
			msg = 'PC Name (Disabled on Web)';
			#end

			return msg;
		}, () -> {
				#if !html5
				Save.options.get().pcname = !Save.options.get().pcname;
				#end
		}, spr -> {
				#if html5
				spr.shader = new osa.shaders.GrayscaleShader(0.75);
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
	}

	function addOption(assetName:String, gimmeStr:Void->String, gimmeAction:Void->Void, ?specialThing:ClickableSprite->Void)
	{
		var spr:ClickableSprite = makeSprite('options/$assetName', gimmeStr, gimmeAction);

		if (specialThing != null)
			specialThing(spr);

		spriteList.push(spr);
	}

	public static function getEnabledString(value:Bool):String
		return value ? 'Enabled' : 'Disabled';
}
