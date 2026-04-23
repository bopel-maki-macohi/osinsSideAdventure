package flxnovel.util.macros;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Access;

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

		function warning(v:Dynamic)
		{
			haxe.macro.Context.warning(Std.string(v), haxe.macro.Context.currentPos());
		}

		function getType(str:String):ComplexType
		{
			switch (str?.toLowerCase())
			{
				case 'f':
					return Float;
				case 'i':
					return Int;
				case 's':
					return String;
				case 'd':
					return Dynamic;
			}

			warning('Unknown type: $str');
			return Dynamic;
		}

		var constantsText:String = sys.io.File.getContent(file);

		info(file + ' : ' + constantsText);

		for (line in constantsText.split('\n'))
		{
			var trimmedLine:String = line;

			if (trimmedLine.length < 1)
				continue;

			var splitLine:String = trimmedLine.split(' ');

			var type:String = splitLine[0];
			var name:String = splitLine[1];
			var value:String = splitLine[2];

			fields.push({
				name: name, // Field name.
				access: [Access.APublic, Access.AStatic, Access.AFinal], // Access level
				kind: haxe.macro.Expr.FieldType.FVar(macro getType(type), macro $v{cast (value, getType(type))}), // Variable type and default value
				pos: haxe.macro.Context.currentPos(), // The field's position in code.
			});
		}

		return macro $v{fields};
	}
}
