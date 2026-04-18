package osa.states.menus;

import osa.util.SoundUtil;
import osa.util.Constants;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import osa.objects.ClickableSprite;
import flixel.FlxG;

class TitleSubStateBase extends OSASubState
{
	public var onExit:Void->Void;

	public var spriteList:Array<ClickableSprite> = [];

	override public function new(onExit:Void->Void)
	{
		super();

		this.onExit = onExit;
	}

	override function close()
	{
		onExit();

		FlxTimer.wait(OSAState.DEFAULT_TRANSITION.duration, () ->
		{
			if (_parentState != null && _parentState.subState == this)
			{
				_parentState.closeSubState();
			}
		});

		for (obj in members)
			FlxTween.tween(obj, {alpha: 0}, OSAState.DEFAULT_TRANSITION.duration, {
				ease: FlxEase.sineInOut,
				onComplete: t ->
				{
					remove(obj);
					obj.destroy();
				}
			});
	}

	override function update(elapsed:Float)
	{
		setText('');

		super.update(elapsed);

		if (controls.justPressed.LEAVE)
			close();

		if (!TitleState.bgScrolling)
		{
			nonScrollingControls();
		}

		positionSpritesGroup();

		for (sprite in sprites.members)
		{
			if (sprite == null)
				continue;

			if (currentSelection == sprite.ID)
			{
				sprite.overlapUpdate.dispatch();

				if (!TitleState.bgScrolling)
					if (controls.justPressed.ACCEPT)
						sprite.onClick.dispatch();
			}
			else
				sprite.unoverlapUpdate.dispatch();
		}

		displayText.screenCenter();
		displayText.y = FlxG.height - displayText.height - 32;
	}

	public function positionSpritesGroup()
	{
		sprites.x = FlxMath.lerp(sprites.x, currentSelection * -256, 0.1);
	}

	public function nonScrollingControls()
	{
		if (controls.justPressed.LEFT || controls.justPressed.RIGHT)
		{
			if (controls.justPressed.LEFT)
				changeSelection(-1);
			if (controls.justPressed.RIGHT)
				changeSelection(1);
		}
	}

	public function changeSelection(increment:Int)
	{
		currentSelection += increment;

		if (currentSelection < 0)
			currentSelection = sprites.length - 1;
		if (currentSelection > sprites.length - 1)
			currentSelection = 0;

		SoundUtil.selectSfx();
	}

	public var displayText:FlxText;

	public function setText(text:String)
		displayText.text = text;

	public function makeSprite(asset:String, optionText:Void->String, ?onClick:Void->Void):ClickableSprite
	{
		var credSpr:ClickableSprite = new ClickableSprite(0, 0, asset.menuAsset().imageFile());
		credSpr.overlapUpdate.add(() -> setText((optionText == null) ? 'Unknown' : optionText()));

		if (onClick != null)
			credSpr.onClick.add(onClick);

		return credSpr;
	}

	public var sprites:FlxTypedSpriteContainer<ClickableSprite>;

	public var currentSelection:Int = 0;

	override function create()
	{
		super.create();

		sprites = new FlxTypedSpriteContainer<ClickableSprite>();
		sprites.camera = TitleState.blurCamFG;
		sprites.alpha = 0;

		FlxTween.tween(sprites, {alpha: 1}, OSAState.DEFAULT_TRANSITION.duration, {
			ease: FlxEase.sineInOut
		});

		createSprites();

		displayText = new FlxText(0, 0, 0, '', 16);
		displayText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		displayText.camera = TitleState.blurCamFG;
		displayText.alpha = 0;
		displayText.alignment = CENTER;

		FlxTween.tween(displayText, {alpha: 1}, OSAState.DEFAULT_TRANSITION.duration, {
			ease: FlxEase.sineInOut
		});

		add(sprites);
		add(displayText);

		FlxG.mouse.visible = false;

		changeSelection(0);
	}

	public function positionSprites()
	{
		for (sprite in sprites.members)
		{
			sprite.screenCenter();
			sprite.x += sprite.ID * 256;
		}
	}

	public function createSprites()
	{
		for (i => obj in spriteList)
		{
			obj.useMouse = false;

			obj.scale.set(.5, .5);
			obj.updateHitbox();

			obj.ID = i;
			if (addDefaultScaleThingies)
			{
				obj.overlapUpdate.add(() -> ClickableSprite.overlapUpdateScale(obj, .6, .1));
				obj.unoverlapUpdate.add(() -> ClickableSprite.unoverlapUpdateScale(obj, .5, .1));
			}

			sprites.add(obj);
		}

		positionSprites();
	}

	public var addDefaultScaleThingies:Bool = false;
}
