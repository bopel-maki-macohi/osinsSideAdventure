import flixel.FlxSprite;
import flxnovel.data.visualnovel.BackgroundData;

function buildBackground(data:BackgroundData, props:Map<String, FlxSprite>)
{
	props.get('randomImage').screenCenter();
}
