package osa.states.transition;

import flixel.text.FlxText;
import osa.states.menus.TitleState;
import flixel.FlxG;
import flixel.util.FlxTimer;
import osa.states.visualnovel.DialogueSprite;
import osa.states.visualnovel.DialogueLine;
import flixel.FlxState;

class VNCacher extends OSAState
{
	public var _targetState:FlxState;

	public var _leaving:Bool;

	public var _issue:String;

	override public function new(targetState:FlxState, leaving:Bool, issue:String)
	{
		super();

		this._targetState = targetState;

		this._leaving = leaving;

		this._issue = issue;
	}

	public var _imagePaths:Array<String> = [];

	override function create()
	{
		this.transIn = this.transOut = null;

		super.create();

		if (_leaving)
		{
			OSACache.clearTempCaches();
		}
		else
		{
			getImagePaths();

			// trace(_imagePaths);

			for (key in _imagePaths)
				OSACache.tempCacheTexture(key);
		}

		if (_targetState == null)
			FlxG.switchState(() -> new TitleState('STORYMENU'));
		else
			FlxG.switchState(() -> _targetState);
	}

	function getImagePaths()
	{
		var char:DialogueSprite = new DialogueSprite(true);
		var bg:DialogueSprite = new DialogueSprite(false);

		for (rawline in _issue.parseDialogueFile())
		{
			var line:DialogueLine = new DialogueLine(rawline);

			if (line._isEvent)
				continue;

			if (line._character != null)
				char.build(line._character);
			if (line._bg != null)
				bg.build(line._bg);

			if (char?.graphic?.assetsKey != null)
				if (!_imagePaths.contains(char?.graphic?.assetsKey))
					_imagePaths.push(char?.graphic?.assetsKey);

			if (bg?.graphic?.assetsKey != null)
				if (!_imagePaths.contains(bg?.graphic?.assetsKey))
					_imagePaths.push(bg?.graphic?.assetsKey);
		}
	}
}
