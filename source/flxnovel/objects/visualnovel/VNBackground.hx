package flxnovel.objects.visualnovel;

import flxnovel.modding.scripting.ScriptHandler;
import flxnovel.util.WindowUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flxnovel.data.visualnovel.background.BackgroundPropData;
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

		props.clear();
		clear();

		if (data == null)
			return;
		if (data?.props == null || data.props.length < 1)
			return;

		for (i => propData in data.props)
		{
			if (propData?.id == null)
			{
				WindowUtil.alert('VNBackground Warning : Missing Prop ID',
					'Prop #${i + 1} (type: ${propData.type}) is missing an ID and thus cannot be parsed');
				continue;
			}

			switch (propData.type)
			{
				case shape:
					makeShapeProp(propData);

				case image:
					makeImageProp(propData);
			}
		}

		ScriptHandler.call('buildBackground', [this]);
	}

	public var props:Map<String, FlxSprite> = [];

	public function addProp(prop:FlxSprite, id:String)
	{
		if (props.exists(id))
		{
			WindowUtil.alert('VNBackground Warning : Duplicate Prop ID', 'The following prop ID already has been used and cannot be used again: $id');
			return;
		}

		props.set(id, prop);
		add(prop);
	}

	public function makeShapeProp(data:BackgroundPropData)
	{
		if (data?.width == null)
			return;
		if (data?.height == null)
			return;

		var shape:FlxSprite = new FlxSprite().makeGraphic(data.width, data.height, FlxColor.WHITE);
		shape = applyGeneralPropInfo(shape, data);

		addProp(shape, data.id);
	}

	public function makeImageProp(data:BackgroundPropData)
	{
		if (data?.asset == null)
			return;

		var image:FlxSprite = new FlxSprite();
		image.loadGraphic(data.asset.assetPath().imageFile());

		image = applyGeneralPropInfo(image, data);

		addProp(image, data.id);
	}

	public function applyGeneralPropInfo(prop:FlxSprite, data:BackgroundPropData)
	{
		if (data?.color != null)
		{
			var clr:FlxColor = FlxColor.WHITE;
			clr = FlxColor.fromString(data.color) ?? FlxColor.WHITE;

			prop.color = clr;
		}

		if (data.scale != null)
			prop.scale.set(data.scale, data.scale);

		if (data.x != null)
			prop.x = data.x;

		if (data.y != null)
			prop.y = data.y;

		if (data.callbacks != null && data.callbacks.length > 0)
			for (callback in data.callbacks)
			{
				switch (callback)
				{
					case centerXY:
						prop.screenCenter(XY);
					case centerX:
						prop.screenCenter(X);
					case centerY:
						prop.screenCenter(Y);
				}
			}

		return prop;
	}
}
