package osa.util;

class DateUtil
{
	public static function getTimestamp():String
	{
		final dateNow:Date = Date.now();

		final seconds:Float = dateNow.getTime() / 1000;
		final date:String = '${dateNow.getMonth()}-${dateNow.getDate()}-${dateNow.getFullYear()}';

		return '${date}_${seconds}';
	}
}
