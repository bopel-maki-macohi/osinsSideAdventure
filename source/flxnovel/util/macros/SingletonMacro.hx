package flxnovel.util.macros;

import haxe.macro.Context;
import haxe.macro.Type.ClassType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.ComplexType;

using haxe.macro.Tools;

/**
 * A macro which automatically creates a Singleton `instance` property for a class.
 * 
 * Mostly yoinked from FNF
 */
class SingletonMacro
{
	/**
	 * Applies an `instance` static field to the target class that automatically gets made.
	 * @return The modified list of fields for the target class.
	 */
	public static macro function buildAutomake():Array<Field>
	{
		var cls:ClassType = Context.getLocalClass().get();

		var fields:Array<Field> = Context.getBuildFields();

		var clsType:ComplexType = Context.getType('${cls.module}.${cls.name}').toComplexType();
		var newExpr:String = 'new ${cls.module}.${cls.name}()';

		fields = fields.concat((macro class TempClass
			{
				static var _instance:Null<$clsType>;
				public static var instance(get, never):$clsType;

				static function get_instance():$clsType
				{
					if (_instance == null)
					{
						_instance = ${Context.parse(newExpr, Context.currentPos())};
					}
					return _instance;
				}
			}).fields);

		return fields;
	}

	/**
	 * Applies an `instance` static field to the target class that has to be manually made
	 * @return The modified list of fields for the target class.
	 */
	public static macro function buildManualMake():Array<Field>
	{
		var cls:ClassType = Context.getLocalClass().get();

		var fields:Array<Field> = Context.getBuildFields();

		var clsType:ComplexType = Context.getType('${cls.module}.${cls.name}').toComplexType();
		var newExpr:String = 'new ${cls.module}.${cls.name}()';

		fields = fields.concat((macro class TempClass
			{
				public static var instance:$clsType;
			}).fields);

		return fields;
	}
}
