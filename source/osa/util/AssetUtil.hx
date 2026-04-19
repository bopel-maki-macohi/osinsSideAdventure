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

	public static inline function jsonFile(file:String):String
		return '$file.json';

	public static inline function videoFile(file:String):String
		return '$file.mp4';

	public static inline function menuAsset(file:String):String
		return assetPath('menus/$file');

	public static inline function miscAsset(file:String):String
		return assetPath('misc/$file');

	public static inline function visualNovelAsset(file:String):String
		return assetPath('visualnovel/$file');

	public static inline function taleAsset(file:String):String
		return visualNovelAsset('tales/$file');

	public static inline function speakerAsset(speaker:String, file:String):String
		return visualNovelAsset('speakers/$speaker/$file');

	public static inline function scriptFile(file:String):String
		return assetPath('scripts/$file.hx');

	public static inline function shaderFile(file:String):String
		return assetPath('shaders/$file.frag');

	public static inline function fileExists(file:String):Bool
		return Assets.exists(file);

	public static inline function readText(file:String):String
	{
		try
		{
			return Assets.getText(file);
		}
		catch (e)
		{
			trace(e);
			return '';
		}
	}

	public static function textSplit(text:String):Array<String>
	{
		if (!fileExists(text.textFile()))
			return [];

		var file:String = text.textFile().readText();
		var lines:Array<String> = [];

		if (file == null)
		{
			trace('Null file content: $text');
			return [];
		}

		for (line in file.split('\n'))
			if (line.trim().length > 0)
				lines.push(line.trim());

		return lines;
	}

	public static function getFilesInDirectory(directory:String):Array<String>
		return Assets.list().filter(f -> return f.startsWith(directory));
}
