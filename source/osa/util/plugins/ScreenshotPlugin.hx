package osa.util.plugins;

import osa.shaders.GrayscaleShader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxBasic;
#if SCREENSHOT_PLUGIN
import flixel.FlxG;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
#end

/**
	A plugin that allows the player to take screenshots.

	Base Code yoinked from WTFEngine: https://github.com/VirtuGuy/WTF-Engine/blob/main/source/funkin/util/plugins/ScreenshotPlugin.hx
 */
class ScreenshotPlugin extends FlxBasic
{
	public static final SCREENSHOT_FOLDER:String = 'screenshots';

	var _tookScreenshot:Bool = false;

	public static function init()
	{
		#if SCREENSHOT_PLUGIN
		#if sys
		if (!sys.FileSystem.exists(ScreenshotPlugin.SCREENSHOT_FOLDER))
		{
			trace('Created directory ${ScreenshotPlugin.SCREENSHOT_FOLDER}');
			sys.FileSystem.createDirectory(ScreenshotPlugin.SCREENSHOT_FOLDER);
		}
		#end

		FlxG.plugins.addPlugin(new ScreenshotPlugin());
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if SCREENSHOT_PLUGIN
		if (FlxG.keys.justPressed.F3 && !_tookScreenshot)
		{
			_tookScreenshot = true;

			#if sys
			final screenshot:BitmapData = BitmapData.fromImage(FlxG.stage.window.readPixels());
			final bytes:ByteArray = screenshot.encode(screenshot.rect, new PNGEncoderOptions());

			final path = '${ScreenshotPlugin.SCREENSHOT_FOLDER}/screenshot_${Constants.getTimestamp()}.png';

			sys.io.File.saveBytes(path, bytes);
			trace('Saved screenshot to $path');

			fancyPreview(screenshot);
			#else
			trace('Cannot screenshot on this platform');
			#end

			FlxTimer.wait(1, () ->
			{
				_tookScreenshot = false;
				trace('Can screenshot again');
			});
		}
		#end
	}

	function fancyPreview(screenshot:BitmapData)
	{
		var preview:FlxSprite = new FlxSprite(0, 0, screenshot);
		FlxG.state.add(preview);
		preview.screenCenter();

		var grayscale:GrayscaleShader = new GrayscaleShader(1);
		preview.shader = grayscale;

		FlxTween.tween(grayscale, {amount: 0}, 1, {
			ease: FlxEase.sineInOut,
			onUpdate: t ->
			{
				grayscale.setAmount(1 - t.percent);
			}
		});

		FlxTween.tween(preview, {
			'scale.x': 0.2,
			'scale.y': 0.2,
			x: 10,
			y: 10,
			alpha: 0.75,
		}, 1, {
			ease: FlxEase.sineInOut,
			onUpdate: t ->
			{
				preview.updateHitbox();
			},
		});

		FlxTimer.wait(2, () ->
		{
			FlxTween.tween(preview, {y: -preview.height, alpha: 0}, 1, {
				ease: FlxEase.sineInOut,
				onComplete: t ->
				{
					FlxG.state.remove(preview);
					preview.destroy();
				}
			});
		});
	}
}
