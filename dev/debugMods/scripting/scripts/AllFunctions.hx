function create()
{
	trace('create');
}

var calledUpdate:Int = 0;

function update(elapsed:Float)
{
	if (calledUpdate > 4) return;

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
