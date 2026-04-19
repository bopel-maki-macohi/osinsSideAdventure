package osa.modding;

import polymod.fs.ZipFileSystem;
import polymod.Polymod;

class ModCore
{
	public static final MOD_ROOT:String = 'mods';

	public static final API_VERSION_RULE:String = '>=0.12.0 <0.13.0';

	public static var modFileSystem(get, never):ZipFileSystem;

	static function get_modFileSystem():ZipFileSystem
	{
		return new ZipFileSystem({
			modRoot: MOD_ROOT,
			autoScan: true
		});
	}

	static function onPolymodError(e:PolymodError)
	{
		trace('${e.code ?? 'debug'}'.toUpperCase() + ' : ' + e.message);
	}

	public static function reload()
	{
		if (Polymod.onError == null)
			Polymod.onError = onPolymodError;

		Polymod.clearScripts();

		loadAllMods();
	}

	public static function loadAllMods()
	{
		loadMods(getAllModIds());
	}

	public static function getAllModIds():Array<String>
	{
		var modIds:Array<String> = [for (i in getAllMods()) i.id];
		return modIds;
	}

	public static var loadedMods:Map<String, ModMetadata> = [];

	public static function getAllMods():Array<ModMetadata>
	{
		trace('Scanning the mods folder...');

		var modMetadata:Array<ModMetadata> = Polymod.scan({
			modRoot: MOD_ROOT,
			apiVersionRule: API_VERSION_RULE,
			fileSystem: modFileSystem,
			errorCallback: onPolymodError
		});
		trace('Found ${modMetadata.length} mods when scanning.');
		return modMetadata;
	}

	static function loadMods(dirs:Array<String>)
	{
		trace('Attempting to load ${dirs.length} mod(s)');

		var mods = Polymod.init({
			modRoot: MOD_ROOT,
			apiVersionRule: API_VERSION_RULE,
			dirs: dirs,
			framework: OPENFL
		});

		loadedMods = [];
		for (mod in mods)
			loadedMods.set(mod.id, mod);

		trace('Loaded mods: ${[for (mod in loadedMods) mod]}');
	}
}
