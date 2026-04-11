package osa.menus;

import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import osa.objects.ClickableSprite;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUISubState;

class CreditsSubState extends FlxSubState
{
	public var _onExit:Void->Void;

	override public function new(onExit:Void->Void)
	{
		super();

		this._onExit = onExit;
	}

	override function close()
	{
		_onExit();

		FlxTimer.wait(OSAState.DEFAULT_TRANSITION.duration, () ->
		{
			if (_parentState != null && _parentState.subState == this)
				_parentState.closeSubState();
		});

		for (obj in members)
			FlxTween.tween(obj, {alpha: 0}, OSAState.DEFAULT_TRANSITION.duration, {
				ease: FlxEase.sineInOut
			});
	}

	override function update(elapsed:Float)
	{
		setCreditText('');

		super.update(elapsed);

		if (!TitleState.bgScrolling)
		{
			if (FlxG.keys.justPressed.ESCAPE)
				close();
		}

		_creditText.x = (FlxG.mouse.x + 20);

		if (_creditText.x + _creditText.width > FlxG.width)
			_creditText.x -= 40 + _creditText.width;

		_creditText.y = (FlxG.mouse.y - 40);

		if (_creditText.y + _creditText.height < (_creditText.height / 2))
			_creditText.y += 60 + _creditText.height;
	}

	public var _creditText:FlxText;

	public function setCreditText(text:String)
		_creditText.text = text;

	public function makeCreditSprite(asset:String, creditText:String, ?url:String):ClickableSprite
	{
		var credSpr:ClickableSprite = new ClickableSprite(0, 0, asset.menuAsset().imageFile());
		credSpr._overlapUpdate.add(() -> setCreditText(creditText));
		if (url != null)
			credSpr._onClick.add(() -> FlxG.openURL(url));
		
		return credSpr;
	}

	override function create()
	{
		super.create();

		// https://www.youtube.com/watch?v=aDTAem9_Yws
		var pogo:ClickableSprite;

		var x = 128.0;
		var y = 128.0;

		var yi = 0;

		for (xi => obj in [
			makeCreditSprite('credits/maki', 'Maki : Artist, Programmer', 'https://github.com/bopel-maki-macohi'),
			makeCreditSprite('credits/maki', 'Pogo : VS IMPOSTOR (Updog) - Get Your Ass Up! (Temp song for story menu)', 'https://www.youtube.com/watch?v=aDTAem9_Yws'),
		])
		{
			obj.scale.set(.5, .5);
			obj.updateHitbox();

			obj.x = x;
			obj.y = y;

			x += obj.width + (xi * 256);
			if (x > FlxG.width)
			{
				x = 128;
				y += obj.height + (yi * 256);
				yi++;
			}

			obj.alpha = 0;
			obj.camera = TitleState.blurCamFG;

			obj._overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(obj, .6, .1));
			obj._unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(obj, .5, .1));

			FlxTween.tween(obj, {alpha: 1}, OSAState.DEFAULT_TRANSITION.duration, {
				ease: FlxEase.sineInOut
			});

			add(obj);
		}

		_creditText = new FlxText(0, 0, 0, '', 16);
		_creditText.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
		_creditText.camera = TitleState.blurCamFG;

		add(_creditText);
	}
}
