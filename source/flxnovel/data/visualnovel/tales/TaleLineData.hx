package flxnovel.data.visualnovel.tales;

import flxnovel.data.visualnovel.speaker.SpeakerTaleData;

typedef TaleLineData =
{
	var text:String;

    @:optional
    var speaker:SpeakerTaleData;

    @:optional
    var autoSkip:Float;
}
