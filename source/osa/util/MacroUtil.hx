package osa.util;

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
}
