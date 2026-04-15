package osa.util.macros;

#if !display
class OutdatedMacro
{
	public static final HTTP_PATH:String = 'https://raw.githubusercontent.com/bopel-maki-macohi/osinsSideAdventure/refs/heads/stable/version.txt';

	public static macro function getOutdated()
	{
		var outdated:Bool = false;

		#if !display
		haxe.macro.Context.info('Outdated: ${outdated}', haxe.macro.Context.currentPos());
        #end

		return macro $v{outdated};
	}
}
#end
