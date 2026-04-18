package osa.data.visualnovel;

import osa.data.visualnovel.speaker.SpeakerStateData;
import osa.util.Constants;
import json2object.JsonParser;

class SpeakerData extends ObjectData<SpeakerData> implements IIterationBasedData
{
	public var iteration:Int = 0;

	public var states:Array<SpeakerStateData>;

	override public function new(file:String)
	{
		iteration = Constants.ITERATION_SPEAKERDATA;

		super(file);
	}

	override function load(file:String)
	{
		super.load(file);

		if (!file.fileExists())
			return;

		var data:SpeakerData = new JsonParser<SpeakerData>().fromJson(file.readText(), file);

		this.iteration = data?.iteration ?? Constants.ITERATION_SPEAKERDATA;
		this.states = data?.states ?? [];

		switch (data.iteration)
		{
			default:
				trace('No changes required for speajer iteration: ${data.iteration}');
		}
	}

	public function getStateInfo(stateID:String):SpeakerStateData
	{
		for (state in states)
			if (state.id == stateID)
				return state;

		return null;
	}
}
