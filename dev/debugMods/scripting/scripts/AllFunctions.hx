import flixel.util.FlxTimer;
import flxnovel.states.transition.SplashState;
import flxnovel.objects.visualnovel.VNBackground;
import flixel.FlxSprite;
import flxnovel.objects.visualnovel.VNSpeaker;

function create()
{
	trace('create1');
	trace('create2');
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

function buildBackground(bg:VNBackground)
{
	trace('buildBackground: ');
	trace(' * data: ' + bg.data);

	var propKeys:Array<String> = [];

	for (s in bg.props.keys())
	{
		propKeys.push(s);
	}

	trace(' * prop IDs: ' + propKeys);
}

function splashSpecialCase(specialCaseFunc:Dynamic, specialCaseID:String)
{
	trace(specialCaseID);

	if (specialCaseID == 'SURPRISEMF')
	{
		SplashState.instance.specialCase = function()
		{
			trace('ARE YOU SURPRISED BECH?');
			
			FlxTimer.wait(2, SplashState.instance.leave);
		}
	}
}
