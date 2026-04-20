package flxnovel.util;

import flixel.FlxSprite;
import polymod.hscript._internal.PolymodScriptClass;

class ScriptUtil
{
	public static function centerSprite(sprite:FlxSprite)
	{
		sprite.screenCenter();
	}

	public static var DEFAULT_IMPORTS(default, null):Map<String, Dynamic>;

	public static function init()
	{
		buildDEFAULT_IMPORTS();

		trace('${[for (key => val in DEFAULT_IMPORTS) key].length} default import(s)');
	}

	public static function buildDEFAULT_IMPORTS()
	{
		DEFAULT_IMPORTS = [];

		addImport(flixel.FlxBasic);
		addImport(flixel.FlxCamera);
		addImport(flixel.FlxG);
		addImport(flixel.FlxGame);
		addImport(flixel.FlxObject);
		addImport(flixel.FlxSprite);
		addImport(flixel.FlxState);
		addImport(flixel.FlxSubState);

		addAbstractImport('flixel.input.keyboard.FlxKey');

		addImport(flixel.math.FlxMath);
		addAbstractImport('flixel.math.FlxPoint');
		addImport(flixel.math.FlxVelocity);

		addImport(flixel.sound.FlxSound);

		addImport(flixel.text.FlxText);

		addImport(flixel.tweens.FlxEase);
		addImport(flixel.tweens.FlxTween);

		addAbstractImport('flixel.util.FlxColor');

		addImport(lime.utils.Assets);

		addImport(openfl.utils.Assets);

		// addImport(flxnovel.data.ObjectData);

		addImport(flxnovel.data.visualnovel.TaleData);
		addImport(flxnovel.data.visualnovel.SpeakerData);

		addImport(flxnovel.objects.ClickableSprite);
		addImport(flxnovel.objects.HoldToPerformGadge);
		addImport(flxnovel.objects.RhythmManager);
		addImport(flxnovel.objects.TileScrollBG);

		addImport(flxnovel.objects.cutscenes.VideoCutscene);

		addImport(flxnovel.objects.visualnovel.VNSpeaker);

		addImport(flxnovel.save.Save);
		addImport(flxnovel.save.SaveField);

		addImport(flxnovel.shaders.GrayscaleShader);

		addImport(flxnovel.util.AssetUtil);
		addImport(flxnovel.util.Constants);
		addImport(flxnovel.util.Controls);
		addImport(flxnovel.util.DateUtil);
		addImport(flxnovel.util.FloatUtil);
		addImport(flxnovel.util.OutdatedUtil);
		addImport(flxnovel.util.SortUtil);
		addImport(flxnovel.util.SoundUtil);
		addImport(flxnovel.util.VersionUtil);
		addImport(flxnovel.util.WindowUtil);
	}

	public static function addImport(cls:Dynamic)
	{
		DEFAULT_IMPORTS.set(Type.getClassName(cls), cls);
	}

	public static function addAbstractImport(cls:String)
	{
		DEFAULT_IMPORTS.set(cls, PolymodScriptClass.abstractClassImpls.get(cls));
	}
}
