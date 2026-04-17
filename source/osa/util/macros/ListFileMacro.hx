package osa.util.macros;

using StringTools;

#if !display
class ListFileMacro
{
	public static macro function getListFile(file:String)
	{
		var list:Array<String> = [];

		#if !display
		final path:String = 'dev/macros/listfiles/$file.txt';

		if (!sys.FileSystem.exists(path))
		{
			trace('Missing List File : $file');
		}
		else
		{
			var contents:String = sys.io.File.getContent(path);

			for (str in contents.split('\n'))
			{
				list.push(str.trim());
			}

			trace('List File "$file" : $list');
		}
		#end

		return macro $v{list};
	}
}
#end
