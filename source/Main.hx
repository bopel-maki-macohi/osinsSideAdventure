import flxnovel.util.macros.MacroUtil;
import flxnovel.util.VersionUtil;
import flxnovel.objects.debug.DebugDisplay;
import flxnovel.util.Constants;
import lime.app.Application;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	/**
	 * Debug Display in the top-left (by default) corner.
	 * 
	 * Put in Main class to be added above the game.
	 */
	public static var debugDisplay:DebugDisplay;

	public function new()
	{
		super();

		createDebugDisplay();

		setWindowTitle();

		addChildren();
	}

	/**
	 * Initalize the `debugDisplay` object
	 */
	function createDebugDisplay()
	{
		debugDisplay = new DebugDisplay();
		debugDisplay.createBackground();
	}

	/**
	 * Set the window title, different defines can have an effect on it.
	 * So having it in a function is helpful in that way atleast.
	 */
	function setWindowTitle()
	{
		FlxG.stage.window.title = '${Application.current.meta.get('name')} ${VersionUtil.VERSION}';

		if (MacroUtil.isDefined('WINDOWTITLE_GIT'))
			FlxG.stage.window.title += '${Constants.GIT_STRING}';
	}

	/**
	 * Adds all objects for gameplay
	 */
	function addChildren()
	{
		addChild(new FlxGame(1280, 720, flxnovel.InitState));
		addChild(debugDisplay);
	}
}
