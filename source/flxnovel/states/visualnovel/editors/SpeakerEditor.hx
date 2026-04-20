package flxnovel.states.visualnovel.editors;

import flixel.FlxG;
import flxnovel.objects.visualnovel.speakereditor.SpeakerEditorTabMenu;
import flxnovel.data.visualnovel.SpeakerData;
import flxnovel.data.visualnovel.speaker.ISpeakerContainer;

class SpeakerEditor extends FlxNovelState implements ISpeakerContainer
{
	public var _speaker:SpeakerData;

    public var uiBox:SpeakerEditorTabMenu;

	override function create()
	{
        _speaker = SpeakerData.fileBuild(null);

        uiBox = new SpeakerEditorTabMenu(_speaker);

        super.create();
        
		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
