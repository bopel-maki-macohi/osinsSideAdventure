package osa.util.macros;

#if !display
class OutdatedMacro
{
	public static final HTTP_PATH:String = 'https://raw.githubusercontent.com/bopel-maki-macohi/osinsSideAdventure/refs/heads/stable/version.txt';

	public static macro function getOutdated()
	{
		var outdated:Bool = false;

		#if !display
		var pos = haxe.macro.Context.currentPos();
		var http = new haxe.Http(HTTP_PATH);

		http.onData = function(data:String)
		{
			haxe.macro.Context.info('Outdated Check HTTP onData: ${data}', pos);

			outdated = sys.io.File.getContent('version.txt') != data;
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
