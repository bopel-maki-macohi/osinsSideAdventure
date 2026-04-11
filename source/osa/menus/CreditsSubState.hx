package osa.menus;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUISubState;

class CreditsSubState extends FlxSubState
{
	public var _onExit:Void->Void;

	override public function new(onExit:Void->Void)
	{
		super();

		this._onExit = onExit;
	}

	override function close()
	{
		_onExit();

		super.close();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
            close();
	}
}
