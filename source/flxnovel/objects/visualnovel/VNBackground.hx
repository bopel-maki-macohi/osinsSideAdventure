package flxnovel.objects.visualnovel;

import flxnovel.data.visualnovel.BackgroundData;
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

		if (data == null)
			return;
		if (data?.props == null || data.props.length < 1)
			return;

		for (propData in data.props)
		{
			switch (propData.type)
			{
				case shape:

				case image:
					// TBA
			}
		}
	}
}
