package osa.util.debug;

import osa.save.Save;
import flixel.FlxG;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;

class CrashHandler
{
	public static final CRASH_DIRECTORY:String = 'crash';

	public static function init()
	{
		#if sys
		if (!sys.FileSystem.exists(CRASH_DIRECTORY))
		{
			trace('Created CRASH_DIRECTORY: ${CRASH_DIRECTORY}');
			sys.FileSystem.createDirectory(CRASH_DIRECTORY);
		}
		#end

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		FlxG.signals.preUpdate.add(function()
		{
			if (Controls.instance.justPressed.DEBUG_CRASH)
				throw 'F1 Crash';
		});
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

		final filename:String = '$CRASH_DIRECTORY/${Constants.getTimestamp()}.txt';

		errorMessage += '\nGame Version: ${FlxG.stage.application.meta.get('version')}';
		errorMessage += '\nCurrent State: ${currentState}';

		var stateFields:Array<String> = [];

		switch (currentState)
		{
			case 'osa.states.menus.storymenu.StoryMenuState':
				stateFields = [
					'_currentSelection',

					'_chapters',

					'_chapterTitle',
					'_chapterIcon',
					'_chapterDialogueFile'
				];

			case 'osa.states.visualnovel.VNState':
				stateFields = [
					'_dialogueEntry',
					'_dialogueLine',

					'_dialogueCharacter',
					'_dialogueBackground',

					'_dialogueTypingFinished',
				];
		}

		if (stateFields.length > 0)
		{
			for (field in stateFields)
				try
				{
					errorMessage += '\n    $field : ${Std.string(Reflect?.field(FlxG.state, field)) ?? 'Unreceivable'}';
				}
				catch (e)
				{
					errorMessage += '\n    $field : Unreceivable($e)';
				}
		}
		else
		{
			errorMessage += '\n    No Special Fields';
		}
		errorMessage += '\n${Save.saveDataLog()}';

		errorMessage += '\n';
		#if sys
		errorMessage += '\nCrash log saved to: "$filename"';
		#end
		errorMessage += '\nPlease report the crash to the github: https://github.com/bopel-maki-macohi/osinsSideAdventure/issues';

		log(errorMessage);

		#if sys
		sys.io.File.saveContent(filename, errorMessage);
		#end

		FlxG.stage.application.window.alert(errorMessage, baseErrorMessage);

		#if sys
		Sys.sleep(1);
		#end

		FlxG.stage.application.window.close();
	}

	static function log(message:Dynamic)
	{
		#if sys
		Sys.println('[CRASHHANDLER] $message');
		#else
		trace('[CRASHHANDLER] $message');
		#end
	}
}
