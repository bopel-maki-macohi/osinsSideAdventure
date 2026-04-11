package osa.util.debug;

import flixel.FlxG;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;

class CrashHandler
{
	public static function init()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
	}

	static function onUncaughtError(event:UncaughtErrorEvent)
	{
		final baseErrorMessage:String = 'UNCAUGHT ERROR EVENT: "${event.error}"';
		final callStack:Array<haxe.CallStack.StackItem> = haxe.CallStack.exceptionStack(true);

		var errorMessage:String = '$baseErrorMessage\n';

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(innerStackItem, file, line, column):
                    // unhelpful files
					if ([
						'lime/_internal/macros/EventMacro.hx',
						'openfl/display/Preloader.hx',
						'lime/utils/Preloader.hx',
						'lime/app/Module.hx',
						'lime/app/Promise.hx',
						'lime/app/Future.hx',
						'lime/utils/Assets.hx',
						'ApplicationMain.hx',
						'openfl/events/EventDispatcher.hx',
						'openfl/display/DisplayObject.hx',
						'openfl/display/DisplayObjectContainer.hx',
						'lime/net/HTTPRequest.hx',
						'lime/_internal/backend/native/NativeHTTPRequest.hx',
						'lime/system/ThreadPool.hx',
						'lime/_internal/backend/native/NativeApplication.hx',
						'lime/app/Application.hx',
						'openfl/display/Application.hx',
					].contains(file))
						continue;

					errorMessage += '   in ${file}#${line}';
					if (column != null)
						errorMessage += ':${column}';
				case CFunction:
					errorMessage += '[Function] ';
				case Module(m):
					errorMessage += '[Module(${m})] ';
				case Method(classname, method):
					errorMessage += '[Function(${classname}.${method})] ';
				case LocalFunction(v):
					errorMessage += '[LocalFunction(${v})] ';
			}
			errorMessage += '\n';
		}

		var currentState:String = 'No state loaded';
		if (FlxG.game != null && FlxG.state != null)
		{
			var currentStateCls:Null<Class<Dynamic>> = Type.getClass(FlxG.state);
			if (currentStateCls != null)
				currentState = Type.getClassName(currentStateCls) ?? 'No state loaded';
		}

		errorMessage += '\nFlixel Current State: ${currentState}';

		log(errorMessage);
		FlxG.stage.application.window.alert(errorMessage, baseErrorMessage);

		#if sys
		Sys.sleep(1);
		#end

		FlxG.stage.application.window.close();
	}

	static function log(message:Dynamic)
	{
		#if sys
		Sys.println(message);
		#else
		trace(message);
		#end
	}
}
