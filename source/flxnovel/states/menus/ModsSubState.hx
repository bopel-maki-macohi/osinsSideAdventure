package flxnovel.states.menus;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flxnovel.util.SortUtil;
import flxnovel.save.Save;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flxnovel.objects.ClickableSprite;
import flxnovel.modding.ModCore;

class ModsSubState extends TitleSubStateBase
{
	override function create()
	{
		ogEnabledMods = Save.enabledMods.get();

		loadMods();

		super.create();
	}

	override function close()
	{
		if (hasChangedList)
			FlxG.resetGame();
		else
			super.close();
	}

	public function makeModEntry(modID:String)
	{
		var entry:ClickableSprite = makeSprite(null, () -> getModStr(modID), () -> toggleMod(modID));

		if (ModCore.allModMetadata.get(modID).icon != null)
			entry.loadGraphic(FlxGraphic.fromBitmapData(BitmapData.fromBytes(ModCore.allModMetadata.get(modID).icon)));
		else
			entry.loadGraphic('mods/defaultIcon'.menuAsset().imageFile());

		spriteList.push(entry);
	}

	public var ogEnabledMods:Array<String> = [];

	public var hasChangedList:Bool = false;

	function toggleMod(modID:String)
	{
		var enabledMods = Save.enabledMods.get();

		if (enabledMods.contains(modID))
			enabledMods.remove(modID);
		else
			enabledMods.push(modID);
		enabledMods.sort(SortUtil.alphabetically);

		hasChangedList = (enabledMods != ogEnabledMods);
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
			'',
			'Enabled: ${Save.enabledMods.get().contains(modID)}'
		];

		return infos.join('\n');
	}

	public function loadMods()
	{
		for (id in ModCore.allModIDs)
			makeModEntry(id);
	}
}
