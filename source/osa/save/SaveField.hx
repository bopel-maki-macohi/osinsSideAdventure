package osa.save;

import flixel.FlxG;

class SaveField<T>
{
	public var field:String = '';

	public function new(field:String, ?initalValue:T = null)
	{
		this.field = field;

		if (initalValue != null && get() == null)
			set(initalValue);
	}

	public function get():T
		return cast getField(field);

	public function set(value:T)
		setField(field, value);

	public function toString():String
		return '${get()}';

	public static function getField(field:String):Dynamic
	{
		if (!FlxG.save.isBound || FlxG.save.isEmpty())
			return null;

		return Reflect.getProperty(FlxG.save.data, field);
	}

	public static function setField(field:String, value:Dynamic)
	{
		if (FlxG.save.isBound)
			Reflect.setProperty(FlxG.save.data, field, value);
	}
}
