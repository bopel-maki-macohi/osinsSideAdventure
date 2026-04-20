import flxnovel.objects.visualnovel.VNBackground;
import flxnovel.util.ScriptUtil;
import flixel.FlxSprite;

function buildBackground(bg:VNBackground)
{
	var sprite:FlxSprite = bg.props.get('randomImage');

	trace(Std.string(sprite));
	ScriptUtil.centerSprite(sprite);
}
