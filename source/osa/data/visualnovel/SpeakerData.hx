package osa.data.visualnovel;

import osa.data.visualnovel.speaker.*;
import osa.util.Constants;
import json2object.JsonParser;

class SpeakerData extends ObjectData<SpeakerData> implements IIterationBasedData
{
	public var iteration:Int = 0;

	public var states:Array<SpeakerStateData>;

	@:jignored
	public var id:String;

	override public function new(id:String, file:String)
	{
		iteration = Constants.ITERATION_SPEAKERDATA;
		states = [];

		this.id = id;

		super(file);
	}

	public function build(iteration:Int, states:Array<SpeakerStateData>)
	{
		this.iteration = iteration ?? Constants.ITERATION_SPEAKERDATA;
		this.states = states ?? [];
	}

	override function load(file:String)
	{
		super.load(file);

		if (!file.fileExists())
			return;

		var data:SpeakerData = new JsonParser<SpeakerData>().fromJson(file.readText(), file);

		build(data.iteration, data.states);
	}

	public function getStateInfo(stateID:String):SpeakerStateData
	{
		for (state in states)
			if (state.id == stateID)
				return state;

		return null;
	}
}
