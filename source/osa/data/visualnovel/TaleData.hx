package osa.data.visualnovel;

import osa.util.Constants;

class TaleData extends ObjectData<TaleData> implements IIterationBasedData
{
	public var iteration:Int;

	override function load(data:TaleData)
	{
		super.load(data);

		switch (data.iteration)
		{
			default:
				trace('No upgrade required from ${data.iteration}');
		}

		this.iteration = Constants.ITERATION_TALEDATA;
	}
}
