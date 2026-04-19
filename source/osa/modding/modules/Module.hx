package osa.modding.modules;

class Module
{
	public var id:String = '';

	public function new(id:String)
	{
		this.id = id;
	}

	public function toString():String
		return '$id';
}
