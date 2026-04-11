package osa.visualnovel;

class DialogueLine
{
    public static final SPLIT_STRING:String = ';';

	public var _rawline(default, set):String = null;

	public function new(rawline:String)
	{
		this._rawline = rawline;
	}

	function set__rawline(rawline:String):String
	{

        this._line = rawline.split(DialogueLine.SPLIT_STRING)[0] ?? '';
        this._character = rawline.split(DialogueLine.SPLIT_STRING)[1] ?? null;
        this._scene = rawline.split(DialogueLine.SPLIT_STRING)[2] ?? null;

		return rawline;
	}

    public var _character(default, null):String;
    public var _scene(default, null):String;
    public var _line(default, null):String;

    public function toString():String
        return '$_line | $_character | $_scene';
}
