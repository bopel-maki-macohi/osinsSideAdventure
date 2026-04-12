package osa.visualnovel;

class EventRunner
{
	public var game(get, never):VNState;

	function get_game():VNState
		return VNState.instance;

	public function new() {}

	public function run(eventManager:EventManager) {}
}
