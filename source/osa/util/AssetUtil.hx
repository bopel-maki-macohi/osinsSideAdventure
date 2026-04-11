package osa.util;

import lime.utils.Assets;

class AssetUtil
{
	public static inline function assetPath(path:String):String
		return 'assets/$path';

	public static inline function textFile(file:String):String
		return assetPath('$file.txt');

	public static inline function dialogueFile(scene:String):String
		return textFile('dialogue/$scene');

	public static inline function fileExists(file:String):Bool
		return Assets.exists(file);

	public static inline function readText(file:String):String
		return Assets.getText(file);

	public static function parseDialogueFile(scene:String):Array<String>
	{
		if (!fileExists(scene.dialogueFile()))
			return [];

		var file:String = scene.dialogueFile().readText();
		var dialogue:Array<String> = [];

        for (line in file.split('\n'))
            dialogue.push(line.trim());

		return dialogue;
	}
}
