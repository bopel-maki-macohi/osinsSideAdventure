package osa.objects.debug;

import openfl.events.Event;
import osa.util.Constants;
import osa.util.VersionUtil;
import openfl.system.System;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.Shape;
import openfl.text.TextField;

/**
 * Replacement for the FPS counter where the intent was to
 * merge the FPS Counter and Debug Watermark, but now we've got a memory counter so that's cool :D
 * 
 * Majority of the code comes from here: https://github.com/VirtuGuy/WTF-Engine/pull/12/changes#diff-d2dd61f6e96d440be09fd2b86ec512a770b5e925b1a7e8fa2568b845f82652a5
 */
class DebugDisplay extends TextField
{
	public var backgroundOpacity:Float = 0.5;

	public var currentFPS(default, null):Int;

	public var systemMemory(default, null):Float = 0;

	public var maxMemory:Float = 0;

	var times:Array<Float>;

	var debugDisplayBG:Shape;

	override public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

		times = [];

		defaultTextFormat = new openfl.text.TextFormat(flixel.system.FlxAssets.FONT_DEFAULT, 12, FlxColor.WHITE);
	}

	var deltaTimeout:Float = 0.0;

	override function __enterFrame(deltaTime:Float):Void
	{
		debugDisplayBG.visible = this.visible;
		
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000)
			times.shift();

		// If the time between updates is less than 50 milliseconds, don't update the display yet.
		if (deltaTimeout < 50)
		{
			deltaTimeout += deltaTime;
			return;
		}

		systemMemory = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 2)); // Convert bytes to megabytes and round to 2 decimal places.
		if (systemMemory > maxMemory)
			maxMemory = systemMemory; // Update max memory if current memory exceeds it.

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;

		if (visible)
		{
			updateDisplay();
			redrawBackground();
		}
		deltaTimeout = 0.0;
	}

	public function createBackground():Void
	{
		if (parent == null)
		{
			trace('Parent is null, retrying next frame...');
			addEventListener(Event.ADDED_TO_STAGE, retryCreateBackground);
			return;
		}
		debugDisplayBG = new Shape();
		debugDisplayBG.x = this.x;
		debugDisplayBG.y = this.y;
		debugDisplayBG.alpha = backgroundOpacity;
		parent.addChildAt(debugDisplayBG, parent.getChildIndex(this));
		trace('debugDisplayBG Initialized.');
	}

	function retryCreateBackground(_):Void
	{
		if (parent == null)
			return;
		removeEventListener(Event.ADDED_TO_STAGE, retryCreateBackground);
		createBackground();
	}

	function redrawBackground():Void
	{
		if (debugDisplayBG == null)
			return;

		debugDisplayBG.x = this.x;
		debugDisplayBG.y = this.y;
		debugDisplayBG.graphics.clear();

		debugDisplayBG.graphics.beginFill(FlxColor.BLACK, 1);
		debugDisplayBG.graphics.drawRect(-(bgSizeOffset / 2), -(bgSizeOffset / 2), this.width + bgSizeOffset, this.height);
		debugDisplayBG.graphics.endFill();

		debugDisplayBG.alpha = backgroundOpacity;
	}

	public var bgSizeOffset:Int = 10;

	public function updateDisplay():Void
	{
		// If your memory usage is above 1000 megabytes, display it in gigabytes. (default: megabytes)
		var memoryUnit = systemMemory >= 1000 ? 'gb' : 'mb';

		var texts = [
			'OSA: ${VersionUtil.VERSION} (${Constants.GIT_STRING})',

			'FPS: ${currentFPS}',
			'MEM: ${systemMemory} / ${maxMemory}${memoryUnit}',
		];

		text = texts.join('\n');
		width = textWidth * 1.1;

		textColor = FlxColor.WHITE;
		if (maxMemory > 3000 || currentFPS <= FlxG.drawFramerate / 2)
			textColor = FlxColor.RED;
	}
}
