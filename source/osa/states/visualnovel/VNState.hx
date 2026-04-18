package osa.states.visualnovel;

import osa.data.visualnovel.TaleData;

class VNState extends OSAState
{
	public var taleData:TaleData;

	override public function new(taleID:String)
	{
		super();

		taleData = new TaleData(taleID.jsonFile().taleAsset());
	}
}
