package osa.states.visualnovel.cutscenes;

#if html5
import osa.objects.FlxVideo;
#end
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
	public var _blackScreen:FlxSprite;

	#if hxvlc
	public var _vid:FlxVideoSprite;
	#elseif html5
	public var _vid:FlxVideo;
	#end

	public var _finishCallback:FlxSignal = new FlxSignal();

	override public function new()
	{
		super();

		_blackScreen = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		_blackScreen.scrollFactor.set();

		#if hxvlc
		_vid = new FlxVideoSprite(0, 0);

		_vid.active = false;

		_vid.bitmap.onEndReached.add(finishVideo.bind(0.5));

		_vid.bitmap.onFormatSetup.add(function():Void
		{
			if (_vid.bitmap != null && _vid.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / _vid.bitmap.bitmapData.width, FlxG.height / _vid.bitmap.bitmapData.height);

				_vid.setGraphicSize(_vid.bitmap.bitmapData.width * scale, _vid.bitmap.bitmapData.height * scale);
				_vid.updateHitbox();
				_vid.screenCenter();
			}
		});

		_vid.bitmap.onEncounteredError.add(function(msg:String):Void
		{
			trace('Video error: $msg');
			finishVideo(0.5);
		});
		#end
	}

	public function play(cutscene:String)
	{
		FlxTween.cancelTweensOf(_blackScreen);
		_blackScreen.alpha = 1;
		if (!members.contains(_blackScreen))
			add(_blackScreen);

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
		_vid = new FlxVideo(cutscene);

		if (_vid != null)
		{
			_vid.finishCallback = finishVideo.bind(0.5);

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
		if (_vid != null)
		{
			if (!members.contains(_vid))
				add(_vid);

			final fileOptions:Array<String> = [];

			_vid.load(cutscene, fileOptions);
			_vid.play();
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
		#if (html5 || hxvlc)
		if (_vid != null)
		{
			#if hxvlc
			_vid.stop();
			#end
			if (members.contains(_vid))
				remove(_vid);
			_vid.destroy();
		}
		_vid = null;
		#end

		FlxTween.tween(_blackScreen, {alpha: 0}, transitionTime, {
			onComplete: t ->
			{
				if (members.contains(_blackScreen))
					remove(_blackScreen);

				if (_finishCallback != null)
					_finishCallback.dispatch();
			}
		});
	}

	public function pauseVideo():Void
	{
		#if html5
		if (_vid != null)
		{
			_vid.pauseVideo();
			// onVideoPaused.dispatch();
		}
		#end

		#if hxvlc
		if (_vid != null)
		{
			_vid.pause();
			// onVideoPaused.dispatch();
		}
		#end
	}

	public function hideVideo():Void
	{
		_blackScreen.visible = false;

		#if html5
		if (_vid != null)
		{
			_vid.visible = false;
		}
		#end

		#if hxvlc
		if (_vid != null)
		{
			_vid.visible = false;
		}
		#end
	}

	public function showVideo():Void
	{
		_blackScreen.visible = false;

		#if html5
		if (_vid != null)
		{
			_vid.visible = true;
		}
		#end

		#if hxvlc
		if (_vid != null)
		{
			_vid.visible = true;
		}
		#end
	}

	public function resumeVideo():Void
	{
		#if html5
		if (_vid != null)
		{
			_vid.resumeVideo();
			// onVideoResumed.dispatch();
		}
		#end

		#if hxvlc
		if (_vid != null)
		{
			_vid.resume();
			// onVideoResumed.dispatch();
		}
		#end
	}

	public function destroyVideo()
	{
		#if html5
		if (_vid != null)
			remove(_vid);
		#end

		#if hxvlc
		if (_vid != null)
		{
			_vid.stop();
			remove(_vid);
		}
		#end

		#if (html5 || hxvlc)
		if (_vid != null)
		{
			_vid?.destroy();
			_vid = null;
		}
		#end

		if (_blackScreen != null)
		{
			remove(_blackScreen);
			_blackScreen = null;
		}
	}
}
