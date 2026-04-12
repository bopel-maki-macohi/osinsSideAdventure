package osa;

import flixel.text.FlxText;

class PreloaderState extends OSAState
{
	public var _onComplete:Void->Void;

	override public function new(onComplete:Void->Void)
	{
		super();

		this._onComplete = onComplete;
	}

	public var _text:FlxText;

	override function create()
	{
		super.create();

		_text = new FlxText(0, 0, 0, 'PreloaderState', 32);
		add(_text);
	}
}
