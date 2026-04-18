package osa.data.visualnovel;

import osa.data.visualnovel.tales.TaleLineData;
import json2object.JsonParser;
import osa.util.Constants;

class TaleData extends ObjectData<TaleData> implements IIterationBasedData
{
	public var iteration:Int;

	public var lines:Array<TaleLineData>;

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

		this.iteration = data?.iteration ?? Constants.ITERATION_TALEDATA;
		this.lines = data?.lines ?? [];

		switch (data.iteration)
		{
			default:
				trace('No changes required for iteration: ${data.iteration}');
		}
	}
}
