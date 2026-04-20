package flxnovel.util;

class ArrayUtil
{
	public static function merge(a:Array<Any>, b:Array<Any>):Array<Any>
	{
		for (any in b)
		{
			a.push(any);
		}

		return a;
	}
}
