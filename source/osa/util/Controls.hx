package osa.util;

import flixel.addons.input.FlxControls;
import flixel.addons.input.FlxControlInputType.FlxMouseInputType.Motion as MouseMove;
import flixel.addons.input.FlxControlInputType.FlxMouseInputType.Drag as MouseDrag;
import flixel.addons.input.FlxControlInputType.FlxKeyInputType.Multi as MultiKey;
import flixel.addons.input.FlxControlInputType.FlxKeyInputType.Arrows as ArrowKeys;
import flixel.addons.input.FlxControlInputType.FlxGamepadInputType.Multi as MultiPad;
import flixel.addons.input.FlxControlInputType.FlxVirtualPadInputType.Multi as MultiVPad;
import flixel.addons.input.FlxControlInputType.FlxVirtualPadInputType.Arrows as VPadArrows;
import flixel.addons.input.FlxControlInputType.FlxVirtualPadInputID as VPad;
import flixel.input.gamepad.FlxGamepadInputID as GPad;
import flixel.input.keyboard.FlxKey as Key;

enum Inputs
{
	LEFT;
	DOWN;
	UP;
	RIGHT;

	HOLD_SKIP;

	ACCEPT;
	LEAVE;

	TITLE_DEBUG;
	TITLE_DEBUG_TRANSITION;
	SHIFT;
	DEBUG_CRASH;
	SCREENSHOT;
}

class Controls extends FlxControls<Inputs>
{
	public static var instance:Controls;

	function getDefaultMappings():ActionMap<Inputs>
	{
		return [
			LEFT => [Key.LEFT, Key.A],
			DOWN => [Key.DOWN, Key.S],
			UP => [Key.UP, Key.W],
			RIGHT => [Key.RIGHT, Key.D],

			HOLD_SKIP => [Key.SPACE],

			ACCEPT => [Key.ENTER],
			LEAVE => [Key.ESCAPE],

			TITLE_DEBUG => [Key.SEVEN],
			TITLE_DEBUG_TRANSITION => [Key.SPACE],
			SHIFT => [Key.SHIFT],
			DEBUG_CRASH => [Key.F1],
			SCREENSHOT => [Key.F3],
		];
	}
}
