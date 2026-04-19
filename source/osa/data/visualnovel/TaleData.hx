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
		build();

		super(file);
	}

	public function build(?iteration:Int, ?lines:Array<TaleLineData>, ?storymenu:TaleStoryMenuData)
	{
		this.iteration = iteration ?? Constants.ITERATION_TALEDATA;
		this.lines = lines ?? [];
		this.storymenu = storymenu ?? null;
	}

	override function load(file:String)
	{
		super.load(file);

		if (file == null)
			return;

		if (!file.fileExists())
			return;

		var data:TaleData = new JsonParser<TaleData>().fromJson(file.readText(), file);

		build(data.iteration, data.lines, data.storymenu);
	}
}
