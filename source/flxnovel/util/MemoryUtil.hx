package flxnovel.util;

import openfl.system.System;

class MemoryUtil
{
	public static var totalMemory(get, never):Float;

	static function get_totalMemory():Float
	{
		return System.totalMemory;
	}
}
