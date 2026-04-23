package flxnovel.util.macros;

class MacroUtil
{
	/**
	 * Yoinked from FNF
	 */
	public static macro function getDefine(key:String, ?defaultValue:String):haxe.macro.Expr
	{
		var value:Null<String> = haxe.macro.Context.definedValue(key);

		if (value == null)
			value = defaultValue;

		return macro $v{value};
	}

	public static macro function isDefined(key:String):haxe.macro.Expr
	{
		return macro $v{(haxe.macro.Context.definedValue(key) != null)};
	}

	public static macro var HAS_USER:Bool = false;

	public static macro function getUSR()
	{
		#if windows
		HAS_USER = true;
		return macro $v{Sys.environment()["USERNAME"]};
		#elseif (linux || macos)
		HAS_USER = true;
		return macro $v{Sys.environment()["USER"]};
		#elseif html5
		HAS_USER = false;
		return macro $v{'Browser'};
		#else
		HAS_USER = false;
		return macro $v{'Unknown'};
		#end
	}
}
