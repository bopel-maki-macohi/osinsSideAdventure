package osa.util;

using StringTools;

class OutdatedUtil
{
	public static final HTTP_PATH:String = 'https://raw.githubusercontent.com/bopel-maki-macohi/osinsSideAdventure/refs/heads/stable/version.txt';

	public static function getLatestVersion()
	{
		var latestVer = '';

		var http = new haxe.Http(HTTP_PATH);

		http.onData = function(data:String)
		{
			latestVer = data.trim();

			trace('Outdated Check Latest Version: ${latestVer}');
		}

		http.onError = function(error:Dynamic)
		{
			trace('Outdated Check HTTP Error: ${error}');
		}

		http.request();

		return latestVer;
	}
}
