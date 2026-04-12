package osa.visualnovel;

enum EventRunnerDialogueFile
{
	ANY;
	NONE;
	SCENE(scene:String);
}

class EventRunner
{
	public var _game(get, never):VNState;

	function get__game():VNState
		return VNState.instance;

	public var _dialogueFileType(default, null):EventRunnerDialogueFile;

	public function new(dialogueFileType:EventRunnerDialogueFile)
	{
		this._dialogueFileType = dialogueFileType;
	}

	public function runDialogueEvent(eventManager:EventManager) {}

	public function continueLine(eventManager:EventManager) {}

	public function update(eventManager:EventManager, elapsed:Float) {}

	public function onCreate(eventManager:EventManager) {}

	public function onEnd(eventManager:EventManager) {}
}
