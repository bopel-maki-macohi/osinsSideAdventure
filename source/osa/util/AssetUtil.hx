package osa.util;

import lime.utils.Assets;

class AssetUtil
{
	public static inline function assetPath(path:String):String
		return 'assets/$path';

	public static inline function textFile(file:String):String
		return '$file.txt';

	public static inline function imageFile(file:String):String
		return '$file.png';

	public static inline function audioFile(file:String):String
		return '$file.wav';

	public static inline function dialogueAsset(file:String):String
		return assetPath('dialogue/$file');

	public static inline function backgroundAsset(file:String):String
		return assetPath('backgrounds/$file');

	public static inline function characterAsset(file:String):String
		return assetPath('characters/$file');

	public static inline function menuAsset(file:String):String
		return assetPath('menus/$file');

	public static inline function miscAsset(file:String):String
		return assetPath('misc/$file');

	public static inline function shaderFile(file:String):String
		return assetPath('shaders/$file.frag');

	public static inline function fileExists(file:String):Bool
		return Assets.exists(file);

	public static inline function readText(file:String):String
		return Assets.getText(file);

	public static function textSplit(text:String):Array<String>
	{
		if (!fileExists(text.textFile()))
			return [];

		var file:String = text.textFile().readText();
		var lines:Array<String> = [];

		for (line in file.split('\n'))
			if (line.trim().length > 0)
				lines.push(line.trim());

		return lines;
	}

	public static function parseDialogueFile(scene:String):Array<String>
	{
		return textSplit(scene.dialogueAsset());
	}
}
