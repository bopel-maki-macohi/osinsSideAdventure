package dev.post_0_12.scripts;

import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.crypto.Sha256;
import sys.FileSystem;
import haxe.crypto.Sha1;
import sys.io.File;

/**
 * haxe -m dev.post_0_12.scripts.TalePackManager --interp
 */
class TalePackManager
{
	public static var toEncrypt:Array<String> = [
		'dev/launchMods/osa/visualnovel/tales/OSAChapter1.json',
		'assets/visualnovel/tales/lorem.json',
		'assets/visualnovel/tales/lorem2.json',
	];

	static function main()
	{
		encrypt();

		decrypt();
	}

	static var signature:String = 'signature';

	static function encrypt()
	{
		var talePack:Array<String> = [signature];

		for (filePath in toEncrypt)
			talePack.push(Sha256.encode(File.getContent(filePath)));

		File.saveContent('dump/talePacks/generator/${Date.now().getTime() / 1000}.txt', talePack.join('\n'));
	}

	static function decrypt()
	{
		var files:Map<String, String> = [];

		for (i => file in FileSystem.readDirectory('dump/talePacks/generator'))
		{
			var path = 'dump/talePacks/generator/$file';
			var content = File.getContent(path);

			if (content.split('\n')[0] == signature)
				for (j => s in content.split('\n'))
				{
					if (i < 1)
						continue;

                    var piece = content.split('\n')[j];
				}
		};

		for (key => value in files)
		{
			File.saveContent('dump/talePacks/decrypt/$key.txt', value);
		}
	}
}
