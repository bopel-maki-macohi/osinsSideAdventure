package flxnovel.data.visualnovel.tales;

import flxnovel.data.visualnovel.speaker.SpeakerTaleData;

typedef TaleLineData =
{
	var text:String;

	@:optional
	var speaker:SpeakerTaleData;

	@:optional
	@:default(0)
	var autoSkip:Float;

	@:optional
	@:default('')
	var background:String;
}
