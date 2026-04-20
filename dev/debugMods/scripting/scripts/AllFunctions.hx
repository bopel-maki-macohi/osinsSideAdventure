import osa.data.visualnovel.SpeakerData;

function create()
{
	trace('create');
}

var calledUpdate:Int = 0;

function update(elapsed:Float)
{
	if (calledUpdate > 4)
		return;

	calledUpdate += 1;
	trace('update : ' + elapsed);
}

function onBeatHit(beat:Int)
{
	trace('beat: $beat');
}

function onStepHit(step:Int)
{
	trace('step: $step');
}

function onAttemptedUnderflow() {}
function onChangedLine(line:Int) {}
function onDialogueStartedWriting() {}
function onDialogueFinishedWriting() {}
function onBuiltSpeaker(speaker:SpeakerData) {}
function onEndTale(validEnd:Bool) {}
