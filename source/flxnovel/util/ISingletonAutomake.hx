package flxnovel.util;

/**
 * An interface which applies a macro to add a Singleton `instance` property to the class.
 */
@:autoBuild(flxnovel.util.macros.SingletonMacro.buildAutomake())
interface ISingletonAutomake {}
