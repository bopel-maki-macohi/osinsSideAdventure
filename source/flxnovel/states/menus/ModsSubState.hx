package flxnovel.states.menus;

import flxnovel.modding.ModCore;

class ModsSubState extends TitleSubStateBase
{
	override function create()
	{
		loadMods();

		super.create();
	}

	public function makeModEntry(modID:String) {}

	public function loadMods()
	{
		for (id in ModCore.allModIDs)
		{
			makeModEntry(id);
		}
	}
}
