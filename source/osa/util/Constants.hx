package osa.util;

class Constants
{
	public static final DEFAULT_BLUR_FOCUS:Float = 0;
	public static final DEFAULT_BLUR_UNFOCUS:Float = 4;

	public static final DEFAULT_LERP_SPEED:Float = 0.04;

	public static function getTimestamp():String
	{
		final dateNow:Date = Date.now();

		final seconds:Float = dateNow.getTime() / 1000;
		final date:String = '${dateNow.getMonth()}-${dateNow.getDate()}-${dateNow.getFullYear()}';

		return '${date}_${seconds}';
	}
}
