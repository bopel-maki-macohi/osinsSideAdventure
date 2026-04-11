package osa.util.debug;

import openfl.events.UncaughtErrorEvent;
import openfl.Lib;

class CrashHandler
{
	public static function init()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
	}

	static function onUncaughtError(e:UncaughtErrorEvent)
	{
		trace(e.toString());
	}
}
