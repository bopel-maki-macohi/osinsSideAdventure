package flxnovel.util;

import flixel.addons.input.FlxControlInputType;
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
	MOD_RELOAD;

	VOLUME_UP;
	VOLUME_DOWN;
	VOLUME_MUTE;
}

class Controls extends FlxControls<Inputs>
{
	public static var instance:Controls;

	public var keys(get, never):Map<Inputs, Array<Key>>;

	function get_keys():Map<Inputs, Array<Key>>
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
			MOD_RELOAD => [Key.F5],

			VOLUME_UP => [Key.PLUS, Key.NUMPADPLUS],
			VOLUME_DOWN => [Key.MINUS, Key.NUMPADMINUS],
			VOLUME_MUTE => [Key.ZERO],
		];
	}

	function getDefaultMappings():ActionMap<Inputs>
	{
		var k:ActionMap<Inputs> = [];

		for (input => key in keys)
		{
			var newKeys:Array<FlxControlInputType> = [];

			for (ks in key)
				newKeys.push(FlxControlInputType.fromKey(ks));

			k.set(input, newKeys);
		}

		return k;
	}

	public function getKeyStrings(input:Inputs):Array<String>
	{
		var keyStrings:Array<String> = [];

		for (key in keys.get(input))
		{
			keyStrings.push(key.toString());
		}

		return keyStrings;
	}
}
