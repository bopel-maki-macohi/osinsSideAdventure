import osa.objects.debug.DebugDisplay;
import flixel.system.FlxAssets;
import osa.util.Constants;
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

		debugDisplay = new DebugDisplay(5, 5);

		FlxG.stage.window.title = '${Application.current.meta.get('name')} ${Application.current.meta.get('version')}';

		#if WINDOWTITLE_GIT
		FlxG.stage.window.title += ' (${Constants.GIT_STRING})';
		#end

		addChild(new FlxGame(1280, 720, osa.InitState));
		addChild(debugDisplay);
	}
}
