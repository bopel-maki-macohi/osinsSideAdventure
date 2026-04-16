package osa.util.macros;

#if !display
class TypingSoundMacro {
    public static macro function getTypingSoundMap()
    {
        var output:Map<String, String> = [];

        #if !display
        var pos = haxe.macro.Context.currentPos();
        var directory:String = 'assets/visualnovel/sounds/typing';

        // No sub-directory support, not right now.
        for (file in sys.FileSystem.readDirectory(directory))
        {
        }

        haxe.macro.Context.info('Output: ${output}', pos);
        #end

        return macro $v{output};
    }
}
#end