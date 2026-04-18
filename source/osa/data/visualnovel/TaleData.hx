package osa.data.visualnovel;

import osa.data.visualnovel.tales.*;
import json2object.JsonParser;
import osa.util.Constants;

class TaleData extends ObjectData<TaleData> implements IIterationBasedData
{
	public var iteration:Int;

	public var lines:Array<TaleLineData>;

	public var storymenu:TaleStoryMenuData;

	override public function new(file:String)
	{
		iteration = Constants.ITERATION_TALEDATA;
		lines = [];
		storymenu = null;

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
		this.storymenu = data?.storymenu ?? null;
	}
}
