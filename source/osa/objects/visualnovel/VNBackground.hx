package osa.objects.visualnovel;

import osa.data.visualnovel.BackgroundData;
import flixel.group.FlxSpriteGroup;

class VNBackground extends FlxSpriteGroup
{
	public var data:BackgroundData = null;

	override public function new(data:BackgroundData)
	{
		super();

		this.data = data;

		build();
	}

	public function build()
	{
        if (members.length > 0)
		for (sprite in members)
		{
			members.remove(sprite);
			sprite.destroy();
		}

		clear();
	}
}
