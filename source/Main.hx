import flxnovel.util.VersionUtil;
import flxnovel.objects.debug.DebugDisplay;
import flixel.system.FlxAssets;
import flxnovel.util.Constants;
import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.FPS;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var debugDisplay:DebugDisplay;

	public function new()
	{
		super();

		debugDisplay = new DebugDisplay();
		debugDisplay.createBackground();

		FlxG.stage.window.title = '${Application.current.meta.get('name')} ${VersionUtil.VERSION}';

		#if WINDOWTITLE_GIT
		FlxG.stage.window.title += '${Constants.GIT_STRING}';
		#end

		addChild(new FlxGame(1280, 720, flxnovel.InitState));
		addChild(debugDisplay);
	}
}
