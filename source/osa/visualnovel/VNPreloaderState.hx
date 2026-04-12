package osa.visualnovel;

import flixel.FlxState;
import flixel.text.FlxText;

class VNPreloaderState extends OSAState
{
	public var _vnState:FlxState;
	public var _issue:String;

	override public function new(vnState:FlxState, issue:String)
	{
		super();

		this._vnState = vnState;
		this._issue = issue;
	}

	public var _text:FlxText;

	override function create()
	{
		super.create();

		_text = new FlxText(0, 0, 0, 'PreloaderState', 32);
		add(_text);
	}
}
