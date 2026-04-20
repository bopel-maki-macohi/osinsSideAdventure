package flxnovel.util;

/**
 * Utilities for performing common math operations.
 * 
 * Yoinked from FNF
 */
@:nullSafety
class FloatUtil
{
	/**
	 * Constrain a float between a minimum and maximum value.
	 */
	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}
}
