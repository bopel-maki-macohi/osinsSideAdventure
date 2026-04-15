package osa.util.macros;

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

	public static macro function getUSR()
		return macro $v{#if windows Sys.environment()["USERNAME"] #elseif (linux || macos) return Sys.environment()["USER"] #else 'Browser' #end};
}
