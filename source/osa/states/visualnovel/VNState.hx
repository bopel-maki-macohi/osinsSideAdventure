package osa.states.visualnovel;

class VNState extends OSAState
{
	public var _tale:String = '';

	override public function new(tale:String)
	{
		super();

		this._tale = tale;
	}
}
