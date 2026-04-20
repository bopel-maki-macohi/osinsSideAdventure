package flxnovel.data.visualnovel;

import json2object.JsonParser;
import flxnovel.util.Constants;

class BackgroundData extends ObjectData<BackgroundData>
{
	public var iteration:Int;

	public var props:Array<BackgroundPropData>;

	@:jignored
	public var id:String;

	override public function new(id:String, file:String)
	{
		this.id = id;
		build();

		super(file);
	}

	public static function fileBuild(file:String)
	{
		return new BackgroundData(file, file.visualNovelBackgroundAsset().jsonFile());
	}

	public function build(?iteration:Int, ?props:Array<BackgroundPropData>)
	{
		this.iteration = iteration ?? Constants.ITERATION_BACKGROUNDDATA;
		this.props = props ?? [];
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
