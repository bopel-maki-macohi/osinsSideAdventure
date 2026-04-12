package osa.menus;

import osa.util.Constants;
import flixel.math.FlxMath;
import osa.save.Save;
import osa.visualnovel.VNState;
import osa.objects.ClickableSprite;
import osa.objects.RhythmManager;
import flixel.FlxG;
import flixel.sound.FlxSound;

class StoryMenuSubState extends TitleSubStateBase
{
	public var _getYourAssUp:FlxSound;

	public var _issues:Array<String> = [];
	public var _issueDialogueFile:String;

	override public function new(onExit:Void->Void)
	{
		super(onExit);

		for (issue in Save.issues.get())
		{
			_issues.push(issue);
			_spriteList.push(makeSprite('story/$issue', () -> return issue));
		}
	}

	override function create()
	{
		super.create();

		_getYourAssUp = new FlxSound().loadEmbedded('updog/get-your-ass-up'.miscAsset().audioFile(), true);
		_getYourAssUp.fadeIn(OSAState.DEFAULT_TRANSITION.duration);

		_rhythmManager.reset();
		_rhythmManager._bpm = 110;

		onBeatHit(0);
	}

	override function makeSprite(asset:String, optionText:() -> String, ?onClick:() -> Void):ClickableSprite
	{
		return super.makeSprite(asset, optionText, function()
		{
			onClick();
			onEnter();
		});
	}

	function onEnter()
	{
		FlxG.switchState(() -> new VNState(_issueDialogueFile));
	}

	override function close()
	{
		_getYourAssUp.fadeOut(OSAState.DEFAULT_TRANSITION.duration);

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
			final scale = 1.1 + (i / 10);

			sprite.scale.set(scale, scale);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		_rhythmManager._time += elapsed * RhythmManager.MS_PER_SEC;

		for (i => sprite in _sprites.members)
		{
			final scale = FlxMath.lerp(sprite.scale.x, 1, Constants.DEFAULT_LERP_SPEED);

			sprite.scale.set(scale, scale);
		}
	}

	override function changeSelection(increment:Int)
	{
		super.changeSelection(increment);

		_issueDialogueFile = _issues[_currentSelection];
	}
}
