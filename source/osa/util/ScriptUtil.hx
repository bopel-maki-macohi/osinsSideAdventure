package osa.util;

import polymod.hscript._internal.PolymodScriptClass;

class ScriptUtil
{
	public static var DEFAULT_IMPORTS(default, null):Map<String, Dynamic>;

	public static function init()
	{
		buildDEFAULT_IMPORTS();

		trace('${[for (key => val in DEFAULT_IMPORTS) key]} default import(s)');
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

		// addImport(osa.data.ObjectData);

		addImport(osa.data.visualnovel.TaleData);
		addImport(osa.data.visualnovel.SpeakerData);

		addImport(osa.objects.ClickableSprite);
		addImport(osa.objects.HoldToPerformGadge);
		addImport(osa.objects.RhythmManager);
		addImport(osa.objects.TileScrollBG);

		addImport(osa.objects.cutscenes.VideoCutscene);

		addImport(osa.objects.visualnovel.VNSpeaker);

		addImport(osa.save.Save);
		addImport(osa.save.SaveField);

		addImport(osa.shaders.GrayscaleShader);

		addImport(osa.util.AssetUtil);
		addImport(osa.util.Constants);
		addImport(osa.util.Controls);
		addImport(osa.util.DateUtil);
		addImport(osa.util.FloatUtil);
		addImport(osa.util.OutdatedUtil);
		addImport(osa.util.SortUtil);
		addImport(osa.util.SoundUtil);
		addImport(osa.util.VersionUtil);
		addImport(osa.util.WindowUtil);
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
