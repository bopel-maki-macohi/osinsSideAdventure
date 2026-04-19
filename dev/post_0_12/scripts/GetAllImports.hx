/**
 * cd dev/post_0_12/scripts
 * haxe -m GetAllImports.hx --interp
 */

import sys.io.File;
import sys.FileSystem;

using StringTools;

class GetAllImports
{
	static function read(dir:String):Array<String>
	{
		var cont:Array<String> = [];

		for (file in FileSystem.readDirectory(dir))
		{
			final path = dir + '/' + file;

			if (FileSystem.isDirectory(path))
				for (subpath in read(path))
					cont.push(subpath);
			else
				cont.push(path);
		}

		return cont;
	}

	static function main()
	{
		var allSourceFiles:Array<String> = read('../../../source').filter(f -> return f.endsWith('.hx'));

		var imports:Array<String> = [];

		for (filePath in allSourceFiles)
		{
			var sourceFile:String = File.getContent(filePath);

			var sourceFileLines = [

				for (line in sourceFile.split('\n'))
					if (line.trim().length > 0) line.trim()
			];

			for (line in sourceFileLines)
				if (line.startsWith('import '))
					imports.push(line);
		}

		var listed:Array<String> = [];

		for (imp in imports)
		{
			var uses:Array<String> = imports.filter(f -> f == imp);

			var line:String = imp + ' // ${uses.length}';

			if (uses.length > 1)
			{
				if (listed.contains(line))
					continue;

				trace(line);
				listed.push(line);
			}
		}

		File.saveContent('Imports.txt', listed.join('\n'));
	}
}
