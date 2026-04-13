package osa.states.menus;

import osa.states.transition.VNCacher;
import osa.util.Constants;
import flixel.math.FlxMath;
import osa.save.Save;
import osa.states.visualnovel.VNState;
import osa.objects.ClickableSprite;
import osa.objects.RhythmManager;
import flixel.FlxG;
import flixel.sound.FlxSound;

class StoryMenuSubState extends TitleSubStateBase
{
	public var _issues:Array<String> = [];
	public var _issueDialogueFile:String;

	override public function new(onExit:Void->Void)
	{
		super(onExit);

		for (issue in Save.issues.get())
		{
			_issues.push(issue);
			_spriteList.push(makeSprite('story/$issue', () -> return ''));
		}
	}

	override function create()
	{
		super.create();

		FlxG.sound.playMusic('updog/get-your-ass-up'.miscAsset().audioFile());
		FlxG.sound.music.fadeIn(OSAState.DEFAULT_TRANSITION.duration);

		_rhythmManager.reset();
		_rhythmManager._bpm = 110;

		onBeatHit(0);

		_text.visible = false;
	}

	override function makeSprite(asset:String, optionText:() -> String, ?onClick:() -> Void):ClickableSprite
	{
		return super.makeSprite(asset, optionText, function()
		{
			if (onClick != null)
				onClick();
			onEnter();
		});
	}

	function onEnter()
	{
		FlxG.sound.music.fadeOut(OSAState.DEFAULT_TRANSITION.duration);
		FlxG.switchState(() -> new VNCacher(new VNState(_issueDialogueFile), false, _issueDialogueFile));
	}

	override function close()
	{
		FlxG.sound.music.fadeOut(OSAState.DEFAULT_TRANSITION.duration);

		super.close();
	}

	override function destroy()
	{
		super.destroy();

		_rhythmManager.reset();
	}

	override function onBeatHit(curBeat:Int)
	{
		super.onBeatHit(curBeat);

		for (i => sprite in _sprites.members)
		{
			final scale = 0.6 + (i / 100);

			sprite.scale.set(scale, scale);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		_rhythmManager._time += elapsed * RhythmManager.MS_PER_SEC;

		for (i => sprite in _sprites.members)
		{
			final scale = FlxMath.lerp(sprite.scale.x, 0.5, Constants.DEFAULT_LERP_SPEED);

			sprite.scale.set(scale, scale);
		}
	}

	override function changeSelection(increment:Int)
	{
		super.changeSelection(increment);

		_issueDialogueFile = _issues[_currentSelection];
	}
}
