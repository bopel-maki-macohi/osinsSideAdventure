package osa.states.visualnovel;

enum EventRunnerDialogueFile
{
	ANY;
	NONE;
	SCENE(scene:String);
	SCENES(scenes:Array<String>);
}

class EventRunner
{
	public var _game(get, never):VNState;

	function get__game():VNState
		return VNState.instance;

	public var _dialogueFileType(default, null):EventRunnerDialogueFile;

	public function new(dialogueFileType:EventRunnerDialogueFile = ANY)
	{
		this._dialogueFileType = dialogueFileType;
	}

	public function runDialogueEvent(eventManager:EventManager, ?params:Array<String>) {}

	public function continueLine(eventManager:EventManager) {}

	public function update(eventManager:EventManager, elapsed:Float) {}

	public function onCreate(eventManager:EventManager) {}

	public function onEnd(eventManager:EventManager, validEnd:Bool) {}
}
