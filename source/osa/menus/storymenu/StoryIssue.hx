package osa.menus.storymenu;

class StoryIssue
{
	public static final SPLIT_STRING:String = '\n';

	public var _rawline(default, set):String = null;

	public function new(rawline:String)
	{
		this._rawline = rawline;
	}

	function set__rawline(rawline:String):String
	{
		final splitrawline:Array<String> = rawline?.split(StoryIssue.SPLIT_STRING) ?? null;

		for (i => field in ['_title', '_icon', '_dialoguefile'])
		{
			Reflect.setProperty(this, field, null);

			if (splitrawline == null)
				continue;

			Reflect.setProperty(this, field, splitrawline[i].trim() ?? null);
		}

		return rawline;
	}

	public var _title(default, null):String;
	public var _icon(default, null):String;
	public var _dialoguefile(default, null):String;

	public function toString():String
		return 'StoryIssue(title : $_title | icon : $_icon | dialogueFile : $_dialoguefile)';
}
