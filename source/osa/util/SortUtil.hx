package osa.util;

class SortUtil
{
	/**
	 * yoinked from WTFEngine
	 */
	public static function alphabetically(a:String, b:String):Int
	{
		if (a == b)
			return 0;
		return a < b ? -1 : 1;
	}

	/**
	 * yoinked from WTFEngine
	 */
	public static function defaultsAlphabetically(defaults:Array<String>, a:String, b:String):Int
	{
		if (defaults.contains(a) && defaults.contains(b))
			return defaults.indexOf(a) - defaults.indexOf(b);
		if (defaults.contains(a))
			return -1;
		if (defaults.contains(b))
			return 1;
		return alphabetically(a, b);
	}
}
