package osa.data;

class ObjectData<T>
{
	public function new(file:String)
	{
		load(file);
	}

	@:jignored
	public function load(file:String)
	{
		if (!file.fileExists())
		{
			trace('${Std.string(Type.getClass(this))} : $file does not exist.');
			return;
		}
	}
}
