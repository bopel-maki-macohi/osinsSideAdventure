package flxnovel.modding;

import polymod.util.DefineUtil;
import flxnovel.save.Save;
import flxnovel.modding.scripting.ScriptHandler;
import flxnovel.util.WindowUtil;
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
		final code:String = '${e.code ?? 'debug'}'.toUpperCase();
		var msg:String = code + ' : ' + e.message;

		switch (e.code)
		{
			case null:
				return;

			case MOD_MISSING_ICON:
				return;

			case MOD_MISSING_METADATA:
				msg += '\nThe mod is most likely not there anymore,\nand thus will be removed from your "enabledMods" save field.\n\nPlease remove the mod from your mods folder to avoid seeing this again.';

			default:
		}

		if (e.severity == ERROR || e.severity == WARNING)
			WindowUtil.alert('POLYMOD ${e.severity} : $code', msg.replace(' : ', '\n\n'));
		else
			trace(msg);
	}

	public static var allModIDs(default, null):Array<String> = [];
	public static var allModMetadata(default, null):Map<String, ModMetadata> = [];

	public static function reload()
	{
		if (Polymod.onError == null)
			Polymod.onError = onPolymodError;

		allModIDs = getAllModIds();
		for (modID in Save.enabledMods.get())
			if (!allModIDs.contains(modID))
				Save.enabledMods.get().remove(modID);

		ScriptHandler.clearScripts();
		Polymod.clearScripts();

		loadEnabledMods();

		ScriptHandler.loadScripts();
	}

	public static function loadAllMods()
	{
		loadMods(getAllModIds());
	}

	public static function loadEnabledMods()
	{
		loadMods(Save.enabledMods.get());
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

		for (mod in modMetadata)
		{
			allModMetadata.set(mod.id, mod);
		}

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

	static var extensionMap:Map<String, PolymodAssetType> = ['pdn' => BYTES,];

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

			// scripted classes are disabled until I can figure out the fucking classes apparently already being registered shit
			// useScriptedClasses: true,
			// loadScriptsAsync: #if html5 true #else false #end,

			frameworkParams: {
				coreAssetRedirect: null
			},

			skipDependencyErrors: true,

			extensionMap: extensionMap
		});

		loadedMods = [];
		for (mod in mods)
			loadedMods.set(mod.id, mod);

		var modIDs = [for (mod in loadedMods) mod.id];

		trace('Loaded mods: ${modIDs}');

		for (type in [
			PolymodAssetType.AUDIO_GENERIC,
			PolymodAssetType.AUDIO_MUSIC,
			PolymodAssetType.AUDIO_SOUND,
			// PolymodAssetType.BYTES,
			PolymodAssetType.FONT,
			PolymodAssetType.IMAGE,
			PolymodAssetType.MANIFEST,
			PolymodAssetType.TEMPLATE,
			PolymodAssetType.TEXT,
			PolymodAssetType.UNKNOWN,
			PolymodAssetType.VIDEO,
		])
		{
			var files:Array<String> = [for (asset in Polymod.listModFiles(type)) asset];

			for (file in files)
				if (file == DefineUtil.getDefineString('POLYMOD_MOD_METADATA_FILE'))
					files.remove(file);

			var amt:Int = files.length;

			if (amt > 0)
			{
				trace(' * Replaced / Added ${amt} ${type} file(s)');
				#if LIST_MOD_FILES
				for (file in files)
					trace('   * $file');
				#end
			}
		}
	}
}
