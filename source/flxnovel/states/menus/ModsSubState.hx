package flxnovel.states.menus;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flxnovel.objects.ClickableSprite;
import flxnovel.modding.ModCore;

class ModsSubState extends TitleSubStateBase
{
	override function create()
	{
		loadMods();

		super.create();
	}

	public function makeModEntry(modID:String)
	{
		var entry:ClickableSprite = makeSprite(null, () -> getModStr(modID), () -> {});

		if (ModCore.allModMetadata.get(modID).icon != null)
			entry.loadGraphic(FlxGraphic.fromBitmapData(BitmapData.fromBytes(ModCore.allModMetadata.get(modID).icon)));
		else
			entry.loadGraphic('mods/defaultIcon'.menuAsset().imageFile());

		spriteList.push(entry);
	}

	function getModStr(modID:String)
	{
		var mod = ModCore.allModMetadata.get(modID);
		var infos = [
			'Title: ${mod.title}',
			'Description: ${mod.description}',
			'',
			'Contributors: ${[for (contributor in mod.contributors) contributor.name].join(', ')}',
			'',
			'API Version: ${mod.apiVersion}',
			'Mod Version: ${mod.modVersion}',
		];

		return infos.join('\n');
	}

	public function loadMods()
	{
		for (id in ModCore.allModIDs)
			makeModEntry(id);
	}
}
