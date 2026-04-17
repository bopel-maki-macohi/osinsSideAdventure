package osa.util.macros;

#if !display

/**
 * There's no mod support yet so this stays a macro >:)
 */
class TypingSoundMacro {
    public static macro function getTypingSoundMap()
    {
        var output:Map<String, Array<String>> = [];

        #if !display
        var basedirectory:String = 'assets/visualnovel/';
        var subdirectory:String = 'sounds/typing';

        // No sub-directory support, not right now.
        for (file in sys.FileSystem.readDirectory(basedirectory + subdirectory))
        {
            if (haxe.io.Path.extension(file) != 'wav') continue;
            
            var filePrefix:String = file.split('-')[0];

            if (!output.exists(filePrefix))
                output.set(filePrefix, []);

            output.get(filePrefix).push('$subdirectory/${haxe.io.Path.withoutExtension(file)}');
        }

        trace('Typing Sound Keys: ${[for (key => value in output) key]}');
        #end

        return macro $v{output};
    }
}
#end