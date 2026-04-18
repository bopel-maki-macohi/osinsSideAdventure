package osa.data.visualnovel.tales;

import osa.data.visualnovel.speaker.SpeakerTaleData;

typedef TaleLineData =
{
	var text:String;

    @:optional
    var speaker:SpeakerTaleData;
}
