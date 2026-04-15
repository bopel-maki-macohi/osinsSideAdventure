import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.FPS;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var FPSCounter:FPS;

	public function new()
	{
		super();

		FPSCounter = new FPS(5, 5, FlxColor.WHITE);

		FlxG.stage.application.window.title = '${Application.current.meta.get('name')} ${Application.current.meta.get('version')}';

		addChild(new FlxGame(1280, 720, osa.InitState));
		addChild(FPSCounter);
	}
}
