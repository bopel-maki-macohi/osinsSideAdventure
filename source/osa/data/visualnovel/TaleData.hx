package osa.data.visualnovel;

import json2object.JsonParser;
import osa.util.Constants;

class TaleData extends ObjectData<TaleData> implements IIterationBasedData
{
	public var iteration:Int;

	override public function new(file:String)
	{
		iteration = Constants.ITERATION_TALEDATA;

		super(file);
	}

	override function load(file:String)
	{
		super.load(file);

		if (!file.fileExists())
			return;

		var data:TaleData = new JsonParser<TaleData>().fromJson(file.readText(), file);

		switch (data.iteration)
		{
			default:
				trace('No upgrade required from iteration: ${data.iteration}');
		}

		this.iteration = Constants.ITERATION_TALEDATA;
	}
}
