package flxnovel.states.menus.title;

import flxnovel.util.Constants;
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
		ogEnabledMods = Save.enabledMods.get().copy();

		addDefaultScaleThingies = false;
		useDefaultScale = false;

		spacing = Math.round(Constants.MOD_ICON_SIZE_PIXELS * 1.5);

		loadMods();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
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
			entry.loadGraphic('mods/defaultIcon'.imageFile().menuAsset());

		entry.setGraphicSize(Constants.MOD_ICON_SIZE_PIXELS);
		entry.updateHitbox();

		var curEntryScale = entry.scale.x;

		entry.overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(entry, curEntryScale * 1.1, .1));
		entry.unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(entry, curEntryScale, .1));

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

		Save.enabledMods.set(enabledMods);
		hasChangedList = (enabledMods.copy() != ogEnabledMods.copy());
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
