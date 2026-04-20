package flxnovel.data.visualnovel;

import json2object.JsonParser;
import flxnovel.util.Constants;

class BackgroundData extends ObjectData<BackgroundData>
{
	public var iteration:Int;

	override public function new(file:String)
	{
		build();

		super(file);
	}

	public function build(?iteration:Int)
	{
		this.iteration = iteration ?? Constants.ITERATION_BACKGROUNDDATA;
	}

	override function load(file:String)
	{
		super.load(file);

		if (!file.fileExists())
			return;

		var data:BackgroundData = new JsonParser<BackgroundData>().fromJson(file.readText(), file);

		build(data.iteration);
	}
}
