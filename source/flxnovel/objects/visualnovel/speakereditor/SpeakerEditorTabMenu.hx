package flxnovel.objects.visualnovel.speakereditor;

import flxnovel.data.visualnovel.speaker.ISpeakerContainer;
import flxnovel.data.visualnovel.SpeakerData;
import flixel.addons.ui.FlxUITabMenu;

class SpeakerEditorTabMenu extends FlxUITabMenu implements ISpeakerContainer
{
	public var _speaker:SpeakerData;

	override public function new(tale:SpeakerData)
	{
		super(null, null, [{name: 'Data', label: 'Data'}, {name: 'States', label: 'States'},], true);

		resize(640, 480);

		setPosition(20, 20);
		screenCenter(Y);

		selected_tab = 0;

		_speaker = tale;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
