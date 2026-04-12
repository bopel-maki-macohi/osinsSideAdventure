package osa.menus.storymenu;

import flixel.FlxSprite;

class StoryIssueSprite extends FlxSprite
{
	public var _isIcon:Bool = false;

	override public function new(isIcon:Bool)
	{
		super();

		this._isIcon = isIcon;
	}

	public var _id:String;

	public function build(id:String)
	{
		this._id = id;
		visible = (id != null);

		if (id == null)
			return;

		if (_isIcon)
			loadGraphic('story/icons/$id'.menuAsset().imageFile());
		else
			loadGraphic('story/titles/$id'.menuAsset().imageFile());
		screenCenter();
	}

	override function toString():String
	{
		if (_isIcon)
			return 'StoryIssueSprite(icon : $_id)';

		return 'StoryIssueSprite(title : $_id)';
	}
}
