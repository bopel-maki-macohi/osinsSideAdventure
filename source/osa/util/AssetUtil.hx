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

	public static inline function dialogueFile(file:String):String
		return assetPath('dialogue/$file');

	public static inline function backgroundFile(file:String):String
		return assetPath('backgrounds/$file');

	public static inline function characterFile(file:String):String
		return assetPath('characters/$file');

	public static inline function fileExists(file:String):Bool
		return Assets.exists(file);

	public static inline function readText(file:String):String
		return Assets.getText(file);

	public static function parseDialogueFile(scene:String):Array<String>
	{
		if (!fileExists(scene.dialogueFile().textFile()))
			return [];

		var file:String = scene.dialogueFile().textFile().readText();
		var dialogue:Array<String> = [];

        for (line in file.split('\n'))
            dialogue.push(line.trim());

		return dialogue;
	}
}
