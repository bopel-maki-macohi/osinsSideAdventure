package dev.scripts;

import sys.io.File;
import haxe.Json;

/**
 * haxe -m dev.scripts.ConvertSplashTextsToTXT.hx --interp
 */
class ConvertSplashTextsToTXT
{
	static function main()
	{
		var json:Dynamic = Json.parse(File.getContent('assets/misc/splashTexts.json'));

        var txt:String = '';

        var lines:Array<Dynamic> = json.lines;

        for (thing in lines)
        {
            txt += thing.line.join('--') + '\n';
        }

        File.saveContent('dev/scripts/splashTexts.txt', txt);
	}
}
