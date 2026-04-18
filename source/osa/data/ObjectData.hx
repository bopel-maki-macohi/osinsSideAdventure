package osa.data;

class ObjectData<T>
{
	public function new(file:String)
	{
		if (!file.fileExists())
		{
			trace('$file does not exist.');
			return;
		}
        
		load(file);
	}

	@:jignored
	public function load(file:String) {}
}
