package osa.data;

import osa.util.WindowUtil;

class ObjectData<T>
{
	public function new(file:String)
	{
		if (file != null)
		{
			if (!file.fileExists())
			{
				WindowUtil.alert('ObjectData Error', '"$file" does not exist.');
				return;
			}

			load(file);
		}
		else
		{
			trace('It\'s null...');
		}
	}

	public function load(file:String) {}
}
