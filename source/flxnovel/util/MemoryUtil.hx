package flxnovel.util;

import openfl.system.System;

/**
 * The plan for this was
 * to make the memory counter
 * not be invalid on HTML5 and
 * not just say 0 / 0 mb
 */
class MemoryUtil
{
	public static var totalMemory(get, never):Float;

	static function get_totalMemory():Float
	{
		return System.totalMemory;
	}
}
