package flxnovel.data.visualnovel;

import haxe.io.Path;
import flxnovel.data.visualnovel.speaker.*;
import flxnovel.util.Constants;
import json2object.JsonParser;

class SpeakerData extends ObjectData<SpeakerData> implements IIterationBasedData
{
	public var iteration:Int;

	public var states:Array<SpeakerStateData>;

	@:optional
	public var config:SpeakerConfigData;

	@:jignored
	public var id:String;

	public static var speakers(default, null):Array<String> = [];

	public static function reloadSpeakers():Array<String>
	{
		var newSpeakers:Array<String> = [];

		for (dir in 'speakers/'.visualNovelAsset().getDirectories())
		{
			final speakersDir = dir.getFilesInDirectory().filter(f -> return f.endsWith('data'.jsonFile()));

			for (file in speakersDir)
			{
				var sf = Path.withoutExtension(file).split('/');

				var speakerID = sf[sf.length - 2];

				newSpeakers.push(speakerID);
			}
		}

		speakers = newSpeakers;
		trace('Speakers: $speakers');
	}

	override public function new(id:String, file:String)
	{
		this.id = id;
		build();

		super(file);
	}

	public static function fileBuild(file:String)
	{
		return new SpeakerData(file, file?.visualNovelSpeakerAsset('data'.jsonFile()));
	}

	public function build(?iteration:Int, ?states:Array<SpeakerStateData>, ?config:SpeakerConfigData)
	{
		this.iteration = iteration ?? Constants.ITERATION_SPEAKERDATA;
		this.states = states ?? [];
		this.config = config ?? {};
	}

	override function load(file:String)
	{
		super.load(file);

		if (!file.fileExists())
			return;

		var data:SpeakerData = new JsonParser<SpeakerData>().fromJson(file.readText(), file);

		build(data.iteration, data.states, data.config);
	}

	public function getStateIDS():Array<String>
		return [for (data in states) data.id.trim()];

	public function getStateIDSLowercase():Array<String>
		return [for (id in getStateIDS()) id.toLowerCase()];

	public function hasStateID(id:String):Bool
		return getStateIDS().contains(id.trim());

	public function hasStateIDLowercase(id:String):Bool
		return getStateIDSLowercase().contains(id.trim().toLowerCase());

	public function getStateInfo(stateID:String):SpeakerStateData
	{
		for (state in states)
			if (state.id == stateID)
				return state;

		return null;
	}
}
