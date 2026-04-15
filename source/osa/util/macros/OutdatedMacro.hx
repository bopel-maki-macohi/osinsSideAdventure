package osa.util.macros;

using StringTools;

#if !display
class OutdatedMacro
{
	public static final HTTP_PATH:String = 'https://raw.githubusercontent.com/bopel-maki-macohi/osinsSideAdventure/refs/heads/stable/version.txt';

	public static var LATEST_VERSION:String = '';

	public static macro function getOutdated()
	{
		var outdated:Bool = false;

		#if !display
		var pos = haxe.macro.Context.currentPos();
		var http = new haxe.Http(HTTP_PATH);

		var curVer = sys.io.File.getContent('version.txt').trim();

		http.onData = function(data:String)
		{
			LATEST_VERSION = data.trim();
			
			haxe.macro.Context.info('Outdated Check LATEST_VERSION: ${LATEST_VERSION}', pos);
			haxe.macro.Context.info('Outdated Check curVer: ${curVer}', pos);

			outdated = curVer != LATEST_VERSION;
		}

		http.onError = function(error:Dynamic)
		{
			haxe.macro.Context.warning('Outdated Check HTTP Error: ${error}', pos);
		}

		http.request();

		haxe.macro.Context.info('Outdated: ${outdated}', pos);
		#end

		return macro $v{outdated};
	}
}
#end
