package flxnovel.util.macros;

class ConstantsMacro
{
	public static macro function build(file:String):Array<Field>
	{
		var cls:ClassType = Context.getLocalClass().get();
		var fields:Array<Field> = Context.getBuildFields();

		function info(v:Dynamic)
		{
			haxe.macro.Context.info(Std.string(v), haxe.macro.Context.currentPos());
		}

		var constantsText:String = sys.io.File.getContent(file);

		info(file + ' : ' + constantsText);

		return macro $v{fields};
	}
}
