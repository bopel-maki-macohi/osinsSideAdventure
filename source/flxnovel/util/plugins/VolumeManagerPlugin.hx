package flxnovel.util.plugins;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.FlxBasic;

/**
 * A plugin with the primary focus
 * of fixing the volume keys
 * being active and usable while typing
 */
class VolumeManagerPlugin extends FlxBasic
{
	public var volumeUpKeys:Array<FlxKey> = [];
	public var volumeDownKeys:Array<FlxKey> = [];
	public var muteKeys:Array<FlxKey> = [];

	public static var volumeKeysActive:Bool = false;

	override public function new()
	{
		super();

		FlxG.sound.muteKeys = FlxG.sound.volumeDownKeys = FlxG.sound.volumeUpKeys = [];

		volumeUpKeys = Controls.instance.keys.get(VOLUME_UP);
		volumeDownKeys = Controls.instance.keys.get(VOLUME_DOWN);
		muteKeys = Controls.instance.keys.get(VOLUME_MUTE);
	}

	public static function init()
	{
		FlxG.plugins.addPlugin(new VolumeManagerPlugin());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (volumeKeysActive)
			if (FlxG.keys.anyJustReleased(muteKeys))
				FlxG.sound.toggleMuted();
			else if (FlxG.keys.anyJustReleased(volumeUpKeys))
				FlxG.sound.changeVolume(0.1);
			else if (FlxG.keys.anyJustReleased(volumeDownKeys))
				FlxG.sound.changeVolume(-0.1);
	}
}
