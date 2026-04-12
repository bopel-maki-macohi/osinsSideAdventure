package osa.menus;

import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
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
			FlxG.mouse.visible = true;
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

			if (FlxG.keys.anyJustPressed([A, LEFT]))
				_currentSelection--;
			if (FlxG.keys.anyJustPressed([D, RIGHT]))
				_currentSelection++;
		}

		if (_currentSelection < 0)
			_currentSelection = _creditSprites.length - 1;
		if (_currentSelection > _creditSprites.length - 1)
			_currentSelection = 0;

		_creditSprites.x = FlxMath.lerp(_creditSprites.x, _currentSelection * -256, 0.1);

		for (credit in _creditSprites.members)
		{
			if (_currentSelection == credit.ID)
			{
				credit._overlapUpdate.dispatch();

				if (!TitleState.bgScrolling)
					if (FlxG.keys.justPressed.ENTER)
						credit._onClick.dispatch();
			}
			else
				credit._unoverlapUpdate.dispatch();
		}

		_creditText.screenCenter();
		_creditText.y = FlxG.height - _creditText.height - 32;
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

	public var _creditSprites:FlxTypedSpriteContainer<ClickableSprite>;

	public var _currentSelection:Int = 0;

	override function create()
	{
		super.create();

		_creditSprites = new FlxTypedSpriteContainer<ClickableSprite>();
		_creditSprites.camera = TitleState.blurCamFG;
		_creditSprites.alpha = 0;

		FlxTween.tween(_creditSprites, {alpha: 1}, OSAState.DEFAULT_TRANSITION.duration, {
			ease: FlxEase.sineInOut
		});

		for (i => obj in [
			makeCreditSprite('credits/maki', 'Maki : Artist, Programmer', 'https://github.com/bopel-maki-macohi'),
			makeCreditSprite('credits/pogo', 'Pogo : VS IMPOSTOR (Updog) - Get Your Ass Up! (Temp song for story menu)',
				'https://www.youtube.com/watch?v=aDTAem9_Yws'),
			makeCreditSprite('credits/virtuguy', 'VirtuGuy : WTFEngine and it\'s conductor source code', 'https://github.com/VirtuGuy')
		])
		{
			obj._useMouse = false;

			obj.scale.set(.5, .5);
			obj.updateHitbox();

			obj.ID = i;

			obj._overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(obj, .6, .1));
			obj._unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(obj, .5, .1));

			_creditSprites.add(obj);
		}

		for (sprite in _creditSprites.members)
		{
			sprite.screenCenter();
			sprite.x += sprite.ID * 256;
		}

		_creditText = new FlxText(0, 0, 0, '', 16);
		_creditText.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
		_creditText.camera = TitleState.blurCamFG;

		add(_creditSprites);
		add(_creditText);

		FlxG.mouse.visible = false;
	}
}
