package osa.util.macros;

using StringTools;

#if !display
class OutdatedMacro
{
	public static final HTTP_PATH:String = 'https://raw.githubusercontent.com/bopel-maki-macohi/osinsSideAdventure/refs/heads/stable/version.txt';

	public static macro function getOutdated()
	{
		var latestVer = '';

		#if !display
		var pos = haxe.macro.Context.currentPos();
		var http = new haxe.Http(HTTP_PATH);

		http.onData = function(data:String)
		{
			latestVer = data.trim();

			haxe.macro.Context.info('Outdated Check Latest Version: ${latestVer}', pos);
		}

		http.onError = function(error:Dynamic)
		{
			haxe.macro.Context.warning('Outdated Check HTTP Error: ${error}', pos);
		}

		http.request();
		#end

		return macro $v{latestVer};
	}
}
#end
