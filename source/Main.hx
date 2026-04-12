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

		addChild(new FlxGame(1280, 720, osa.InitState));
		addChild(FPSCounter);
	}
}
