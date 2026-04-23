package flxnovel.data.visualnovel;

import flxnovel.util.IIterationBasedData;
import json2object.JsonWriter;
import flxnovel.data.visualnovel.tales.*;
import json2object.JsonParser;
import flxnovel.util.Constants;

class TaleData extends ObjectData<TaleData> implements IIterationBasedData
{
	public var iteration:Int;

	public var lines:Array<TaleLineData>;

	public var talesmenu:TaleTalesMenuData;

	@:optional
	public var generatedBy:String;

	override public function new(file:String)
	{
		build();

		super(file);
	}

	public static function fileBuild(file:String)
	{
		return new TaleData(file?.jsonFile()?.visualNovelTaleAsset());
	}

	public function build(?iteration:Int, ?lines:Array<TaleLineData>, ?talesmenu:TaleTalesMenuData, ?generatedBy:String)
	{
		trace(lines);

		this.iteration = iteration ?? Constants.ITERATION_TALEDATA;
		this.lines = lines ?? [];
		this.talesmenu = talesmenu ?? null;

		this.generatedBy = generatedBy ?? 'TaleData.build($iteration, $lines, $talesmenu)';
	}

	override function load(file:String)
	{
		super.load(file);

		if (file == null)
			return;

		if (!file.fileExists())
			return;

		trace(file);
		var parser = new JsonParser<TaleData>();
		var data:TaleData = parser.fromJson(file.readText(), file);

		build(data.iteration, data.lines, data.talesmenu, data.generatedBy);
	}
}
