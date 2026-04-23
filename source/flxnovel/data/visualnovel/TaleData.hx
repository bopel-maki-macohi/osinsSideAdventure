package flxnovel.data.visualnovel;

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
		return new TaleData(file?.visualNovelTaleAsset()?.jsonFile());
	}

	public function build(?iteration:Int, ?lines:Array<TaleLineData>, ?talesmenu:TaleTalesMenuData, ?generatedBy:String)
	{
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

		var data:TaleData = new JsonParser<TaleData>().fromJson(file.readText(), file);

		build(data.iteration, data.lines, data.talesmenu, data.generatedBy);
	}

	override public function cleanse():TaleData
	{
		var baseCleanse:TaleData = new TaleData(null);
		baseCleanse.build(iteration, lines, talesmenu, generatedBy);

		var cleansedTaleData:Dynamic = baseCleanse;

		var lines:Array<Dynamic> = cleansedTaleData.lines;

		for (line in lines)
		{
			if (line == null)
				continue;

			if (line?.autoSkip == 0)
				Reflect.deleteField(line, 'autoSkip');

			try
			{
				if (line?.speaker?.id.isBlank())
					Reflect.deleteField(line, 'speaker');

				if (line?.background.isBlank())
					Reflect.deleteField(line, 'background');

				if (line?.text.isBlank())
					Reflect.deleteField(line, 'text');
			}
			catch (e) {}
		}

		if (cleansedTaleData?.talesmenu?.display?.isBlank())
			Reflect.deleteField(cleansedTaleData.talesmenu, 'display');

		if (cleansedTaleData?.talesmenu?.titleAsset?.isBlank())
			Reflect.deleteField(cleansedTaleData.talesmenu, 'titleAsset');

		if (cleansedTaleData?.talesmenu?.filters?.length < 1)
			Reflect.deleteField(cleansedTaleData.talesmenu, 'filters');

		if (Reflect.fields(cleansedTaleData?.talesmenu).length == 0)
			Reflect.deleteField(cleansedTaleData, 'talesmenu');

		if (cleansedTaleData?.generatedBy?.isBlank())
			Reflect.deleteField(cleansedTaleData, 'generatedBy');

		return cleansedTaleData;
	}
}
