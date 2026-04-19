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

		for (imp in imports)
		{
			if (imports.filter(f -> f == imp).length > 1)
				trace(imp);
		}
	}
}
