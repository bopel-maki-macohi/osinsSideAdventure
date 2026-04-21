package flxnovel.data.visualnovel;

import haxe.io.Path;
import json2object.JsonParser;
import flxnovel.util.Constants;
import flxnovel.data.visualnovel.background.BackgroundPropData;

class BackgroundData extends ObjectData<BackgroundData>
{
	public var iteration:Int;

	public var props:Array<BackgroundPropData>;

	@:jignored
	public var id:String;

	public static var backgrounds(default, null):Array<String> = [];
	public static var backgroundsLowercase(default, null):Array<String> = [];

	public static function reloadBackgrounds()
	{
		var newBGs:Array<String> = [];

		for (dir in 'backgrounds/'.visualNovelAsset().getDirectories())
		{
			final bgDir = dir.getFilesInDirectory().filter(f -> return f.endsWith(''.jsonFile()));

			for (file in bgDir)
			{
				var bf = Path.withoutExtension(file).split('/');

				var backgroundID = bf[bf.length - 1];

				newBGs.push(backgroundID);
			}
		}

		backgrounds = newBGs;
		backgroundsLowercase = [for (bg in newBGs) bg.toLowerCase()];

		trace('Backgrounds: $backgrounds');
	}

	override public function new(id:String, file:String)
	{
		this.id = id;
		build();

		super(file);
	}

	public static function fileBuild(file:String)
	{
		return new BackgroundData(file, file?.visualNovelBackgroundAsset()?.jsonFile());
	}

	public function build(?iteration:Int, ?props:Array<BackgroundPropData>)
	{
		this.iteration = iteration ?? Constants.ITERATION_BACKGROUNDDATA;
		this.props = props ?? [];

		if (iteration != null)
			upgradeFrom(iteration);
	}

	public function upgradeFrom(iteration:Int)
	{
		if (this.props != null)
		{
			for (i => propData in this.props)
			{
				if (iteration < 1 && propData.type == 'graphic')
					propData.type = shape;

				if (iteration < 2 && propData?.id == null)
					propData.id = 'prop_$i';
			}
		}

		this.iteration = Constants.ITERATION_BACKGROUNDDATA;

		if (iteration < Constants.ITERATION_BACKGROUNDDATA)
			trace('Upgraded from iteration ${iteration} to iteration ${this.iteration}');
	}

	override function load(file:String)
	{
		super.load(file);

		if (!file.fileExists())
			return;

		var data:BackgroundData = new JsonParser<BackgroundData>().fromJson(file.readText(), file);

		build(data.iteration, data.props);
	}
}
