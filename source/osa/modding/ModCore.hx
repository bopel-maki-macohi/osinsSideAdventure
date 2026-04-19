package osa.modding;

import osa.util.WindowUtil;
import osa.modding.modules.ModuleHandler;
import polymod.format.ParseRules;
import polymod.backends.PolymodAssets.PolymodAssetType;
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
		final msg:String = '${e.code ?? 'debug'}'.toUpperCase() + ' : ' + e.message;

		switch (e.code)
		{
			case MOD_MISSING_ICON:
				return;

			default:
		}

		if (e.severity == ERROR || e.severity == WARNING)
			WindowUtil.alert('Polymod ${e.severity}', msg);
		else
			trace(msg);
	}

	public static function reload()
	{
		if (Polymod.onError == null)
			Polymod.onError = onPolymodError;

		ModuleHandler.clearModules();
		Polymod.clearScripts();

		loadAllMods();

		ModuleHandler.loadModules();
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

	static function buildIgnoreList():Array<String>
	{
		var result = Polymod.getDefaultIgnoreList();

		result.push('.vscode');
		result.push('.haxelib');
		result.push('.idea');
		result.push('.git');
		result.push('.gitignore');
		result.push('.gitattributes');
		result.push('README.md');

		return result;
	}

	static function buildParseRules():polymod.format.ParseRules
	{
		var output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();
		// Ensure TXT files have merge support.
		output.addType('txt', TextFileFormat.LINES);

		// You can specify the format of a specific file, with file extension.
		// output.addFile("data/introText.txt", TextFileFormat.LINES)
		return output;
	}

	static function loadMods(dirs:Array<String>)
	{
		trace('Attempting to load ${dirs.length} mod(s)');

		var mods = Polymod.init({
			modRoot: MOD_ROOT,
			apiVersionRule: API_VERSION_RULE,
			dirs: dirs,
			framework: OPENFL,
			customFilesystem: modFileSystem,
			errorCallback: onPolymodError,

			parseRules: buildParseRules(),
			ignoredFiles: buildIgnoreList(),

			useScriptedClasses: true,
			loadScriptsAsync: #if html5 true #else false #end
		});

		loadedMods = [];
		for (mod in mods)
			loadedMods.set(mod.id, mod);

		var modIDs = [for (mod in loadedMods) mod.id];

		trace('Loaded mods: ${modIDs}');

		for (type in [
			PolymodAssetType.AUDIO_GENERIC,
			// PolymodAssetType.AUDIO_MUSIC,
			// PolymodAssetType.AUDIO_SOUND,
			// PolymodAssetType.BYTES,
			PolymodAssetType.FONT,
			PolymodAssetType.IMAGE,
			// PolymodAssetType.MANIFEST,
			// PolymodAssetType.TEMPLATE,
			PolymodAssetType.TEXT,
			// PolymodAssetType.UNKNOWN,
			PolymodAssetType.VIDEO,
		])
		{
			var amt:Int = [for (asset in Polymod.listModFiles(type)) asset].length;

			if (type == TEXT)
				amt -= modIDs.length; // I don't wanna count the metadata files

			if (amt > 0)
				trace(' * Replaced / Added ${amt} ${type} file(s)');
		}
	}
}
