package osa.visualnovel;

class DialogueLine
{
	public static final SPLIT_STRING:String = ';';
	public static final SKIP_STRING:String = '_';

	public var _rawline(default, set):String = null;

	public function new(rawline:String)
	{
		this._rawline = rawline;
	}

	function set__rawline(rawline:String):String
	{
		final splitrawline:Array<String> = rawline?.split(DialogueLine.SPLIT_STRING) ?? null;

		for (i => field in ['_line', '_character', '_bg'])
		{
			Reflect.setProperty(this, field, null);

			if (splitrawline == null)
				continue;
			if (splitrawline[i] == DialogueLine.SKIP_STRING)
				continue;

			Reflect.setProperty(this, field, splitrawline[i] ?? null);
		}

		return rawline;
	}

	public var _line(default, null):String;
	public var _character(default, null):String;
	public var _bg(default, null):String;

	public function toString():String
		return 'DialogueLine(line: $_line | character: $_character | bg: $_bg)';
}
