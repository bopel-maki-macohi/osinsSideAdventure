import flxnovel.objects.visualnovel.VNSpeaker;

function create()
{
	trace('create1 : 5');
	trace('create2 : 6');
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
	trace('beat: ' + beat);
}

function onStepHit(step:Int)
{
	trace('step: ' + step);
}

function onAttemptedUnderflow()
{
	trace('onAttemptedUnderflow');
}

function onChangedLine(line:Int)
{
	trace('onChangedLine: ' + line);
}

function onDialogueStartedWriting()
{
	trace('onDialogueStartedWriting');
}

function onDialogueFinishedWriting()
{
	trace('onDialogueFinishedWriting');
}

function onBuiltSpeaker(speaker:VNSpeaker)
{
	trace('onBuiltSpeaker: ' + speaker);
}

function onEndTale(validEnd:Bool)
{
	trace('onEndTale: ' + validEnd);
}
