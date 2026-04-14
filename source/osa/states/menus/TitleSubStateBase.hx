package osa.states.menus;

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

class TitleSubStateBase extends OSASubState
{
	public var _onExit:Void->Void;

	public var _spriteList:Array<ClickableSprite> = [];

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
		setText('');

		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			close();

		if (!TitleState.bgScrolling)
		{
			nonScrollingControls();
		}

		positionSpritesGroup();

		for (sprite in _sprites.members)
		{
			if (sprite == null) continue;

			if (_currentSelection == sprite.ID)
			{
				sprite._overlapUpdate.dispatch();

				if (!TitleState.bgScrolling)
					if (FlxG.keys.justPressed.ENTER)
						sprite._onClick.dispatch();
			}
			else
				sprite._unoverlapUpdate.dispatch();
		}

		_text.screenCenter();
		_text.y = FlxG.height - _text.height - 32;
	}

	public function positionSpritesGroup()
	{
		_sprites.x = FlxMath.lerp(_sprites.x, _currentSelection * -256, 0.1);
	}

	public function nonScrollingControls()
	{
		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);
	}

	public function changeSelection(increment:Int)
	{
		_currentSelection += increment;

		if (_currentSelection < 0)
			_currentSelection = _sprites.length - 1;
		if (_currentSelection > _sprites.length - 1)
			_currentSelection = 0;
	}

	public var _text:FlxText;

	public function setText(text:String)
		_text.text = text;

	public function makeSprite(asset:String, optionText:Void->String, ?onClick:Void->Void):ClickableSprite
	{
		var credSpr:ClickableSprite = new ClickableSprite(0, 0, asset.menuAsset().imageFile());
		credSpr._overlapUpdate.add(() -> setText((optionText == null) ? 'Unknown' : optionText()));

		if (onClick != null)
			credSpr._onClick.add(onClick);

		return credSpr;
	}

	public var _sprites:FlxTypedSpriteContainer<ClickableSprite>;

	public var _currentSelection:Int = 0;

	override function create()
	{
		super.create();

		_sprites = new FlxTypedSpriteContainer<ClickableSprite>();
		_sprites.camera = TitleState.blurCamFG;
		_sprites.alpha = 0;

		FlxTween.tween(_sprites, {alpha: 1}, OSAState.DEFAULT_TRANSITION.duration, {
			ease: FlxEase.sineInOut
		});

		for (i => obj in _spriteList)
		{
			obj._useMouse = false;

			obj.scale.set(.5, .5);
			obj.updateHitbox();

			obj.ID = i;

			obj._overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(obj, .6, .1));
			obj._unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(obj, .5, .1));

			_sprites.add(obj);
		}

		positionSprites();

		_text = new FlxText(0, 0, 0, '', 16);
		_text.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		_text.camera = TitleState.blurCamFG;
		_text.alpha = 0;

		FlxTween.tween(_text, {alpha: 1}, OSAState.DEFAULT_TRANSITION.duration, {
			ease: FlxEase.sineInOut
		});

		add(_sprites);
		add(_text);

		FlxG.mouse.visible = false;

		changeSelection(0);
	}

	public function positionSprites()
	{
		for (sprite in _sprites.members)
		{
			sprite.screenCenter();
			sprite.x += sprite.ID * 256;
		}
	}
}
