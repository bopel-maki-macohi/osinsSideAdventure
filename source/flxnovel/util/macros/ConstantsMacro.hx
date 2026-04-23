package flxnovel.util.macros;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Access;

class ConstantsMacro
{
	public static macro function build():Array<Field>
	{
		var cls:ClassType = Context.getLocalClass().get();
		var fields:Array<Field> = Context.getBuildFields();

		function info(v:Dynamic)
		{
            trace(v);
			haxe.macro.Context.info(Std.string(v), haxe.macro.Context.currentPos());
		}

		function warning(v:Dynamic)
		{
            trace('warning: ' + v);
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

			warning('Unimplemented type getter: "$str"');
			return Dynamic;
		}

		function setToType(v:String, t:ComplexType)
		{
			switch (t)
			{
				case String:
					return Std.string(v);
				case Int:
					return Std.parseInt(v);
				case Float:
					return Std.parseInt(v);
			}

			warning('Unimplemented type conversion: "$str"');
			return v;
		}

		var constantsText:String = sys.io.File.getContent('dev/post_0_12/constants.txt');

		info(constantsText);

		for (line in constantsText.split('\n'))
		{
			var trimmedLine:String = line;

			if (trimmedLine.length < 1)
				continue;

			var splitLine:String = trimmedLine.split(' ');

			var type:String = splitLine[0];
			var name:String = splitLine[1];
			var value:Dynamic = splitLine[2];

			fields = fields.concat({
				name: name, // Field name.
				access: [Access.APublic, Access.AStatic, Access.AFinal], // Access level
				kind: haxe.macro.Expr.FieldType.FVar(macro getType(type), macro $v{setToType(value, getType(type))}), // Variable type and default value
				pos: haxe.macro.Context.currentPos(), // The field's position in code.
			});
		}

		return macro $v{fields};
	}
}
