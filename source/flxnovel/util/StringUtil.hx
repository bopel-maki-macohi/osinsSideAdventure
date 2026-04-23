package source.flxnovel.util;

class StringUtil
{
	public static function isBlank(s:String):Bool
	{
		return s == null || s.trim().length < 1;
	}

	public static function notBlank(s:String):Bool
	{
		return !isBlank(s);
	}
}
