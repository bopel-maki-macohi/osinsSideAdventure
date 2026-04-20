package flxnovel.data;

import flxnovel.util.WindowUtil;

class ObjectData<T>
{
	@:jignored
	public var className(get, never):String;

	function get_className():String
	{
		return '${Type.getClass(this)}'.replace('$', '');
	}

	public function new(file:String)
	{
		if (file != null)
		{
			if (!file.fileExists())
			{
				WindowUtil.alert('${className.split('.')[className.split('.').length - 1]} Error', '"$file" does not exist.');
				return;
			}

			load(file);
		}
		else
		{
			trace('$className : Null file');
		}
	}

	public function load(file:String) {}
}
