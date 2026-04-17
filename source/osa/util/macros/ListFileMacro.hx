package osa.util.macros;

#if !display
class ListFileMacro
{
	public static macro function getListFile(file:String)
	{
		var list:Array<String> = [];

		#if !display
		if (!sys.FileSystem.exists(file))
		{
			trace('Missing List File : $file');
		}
		else
		{
			var contents:String = sys.io.File.getContent(file);

			for (str in contents.split('\n'))
			{
				list.push(str);
			}

			trace('List File "$file" : $list');
		}
		#end

		return macro $v{list};
	}
}
#end
