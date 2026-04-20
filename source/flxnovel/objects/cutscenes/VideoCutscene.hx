package flxnovel.objects.cutscenes;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.group.FlxSpriteGroup;
#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end
import flixel.FlxSprite;

/**
 * majority yoinked from fnf
 */
class VideoCutscene extends FlxSpriteGroup
{
	public var blackScreen:FlxSprite;

	#if hxvlc
	public var vid:FlxVideoSprite;
	#elseif html5
	public var vid:FlxVideo;
	#end

	public var finishCallback:FlxSignal = new FlxSignal();

	override public function new()
	{
		super();

		blackScreen = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackScreen.scrollFactor.set();
	}

	public function isPlaying():Bool
	{
		#if (html5 || hxvlc)
		return vid != null;
		#else
		return false;
		#end
	}

	public function play(cutscene:String)
	{
		FlxTween.cancelTweensOf(blackScreen);
		blackScreen.alpha = 1;
		if (!members.contains(blackScreen))
			add(blackScreen);

		#if hxvlc
		playNative(cutscene);
		#elseif html5
		playWeb(cutscene);
		#else
		trace('ALERT: Video cutscenes unsupported!');
		finishVideo(0.5);
		#end
	}

	#if html5
	public function playWeb(cutscene:String)
	{
		// Video displays OVER the FlxState.
		vid = new FlxVideo(cutscene);

		if (vid != null)
		{
			vid.finishCallback = finishVideo.bind(0.5);

			// onVideoStarted.dispatch();
		}
		else
		{
			trace('ALERT: Video is null! Could not play cutscene!');
			finishVideo(0.5);
		}
	}
	#end

	#if hxvlc
	public function playNative(cutscene:String)
	{
		vid = new FlxVideoSprite(0, 0);

		vid.active = false;

		vid.bitmap.onEndReached.add(finishVideo.bind(0.5));

		vid.bitmap.onFormatSetup.add(function():Void
		{
			if (vid.bitmap != null && vid.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / vid.bitmap.bitmapData.width, FlxG.height / vid.bitmap.bitmapData.height);

				vid.setGraphicSize(vid.bitmap.bitmapData.width * scale, vid.bitmap.bitmapData.height * scale);
				vid.updateHitbox();
				vid.screenCenter();
			}
		});

		vid.bitmap.onEncounteredError.add(function(msg:String):Void
		{
			trace('Video error: $msg');
			finishVideo(0.5);
		});

		if (vid != null)
		{
			if (!members.contains(vid))
				add(vid);

			final fileOptions:Array<String> = [];

			vid.load(cutscene, fileOptions);
			vid.play();
			// onVideoStarted.dispatch();
		}
		else
		{
			trace('ALERT: Video is null! Could not play cutscene!');
			finishVideo(0.5);
		}
	}
	#end

	public function finishVideo(?transitionTime:Float = 0.5)
	{
		destroyVideo();

		if (blackScreen != null)
		{
			FlxTween.tween(blackScreen, {alpha: 0}, transitionTime, {
				onComplete: t ->
				{
					if (members.contains(blackScreen))
						remove(blackScreen);
				}
			});
		}
		else
		{
			if (finishCallback != null)
				finishCallback.dispatch();
		}
	}

	public function pauseVideo():Void
	{
		#if (html5 || hxvlc)
		if (vid != null)
		{
			#if html5
			vid.pauseVideo();
			#elseif hxvlc
			vid.pause();
			#end

			// onVideoPaused.dispatch();
		}
		#end
	}

	public function hideVideo():Void
	{
		blackScreen.visible = false;

		#if (html5 || hxvlc)
		if (vid != null)
		{
			vid.visible = false;
		}
		#end
	}

	public function showVideo():Void
	{
		blackScreen.visible = false;

		#if (html5 || hxvlc)
		if (vid != null)
		{
			vid.visible = true;
		}
		#end
	}

	public function resumeVideo():Void
	{
		#if (hxvlc || html5)
		if (vid != null)
		{
			#if html5
			vid.resumeVideo();
			#elseif hxvlc
			vid.resume();
			#end

			// onVideoResumed.dispatch();
		}
		#end
	}

	public function destroyVideo()
	{
		#if (html5 || hxvlc)
		if (vid != null)
		{
			#if hxvlc
			vid.stop();
			#end

			remove(vid);
			vid?.destroy();
			vid = null;
		}
		#end
	}
}
