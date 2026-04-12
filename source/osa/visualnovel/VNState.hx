package osa.visualnovel;

import flixel.group.FlxSpriteGroup;
import osa.menus.TitleState;
import flixel.addons.ui.FlxUIState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import lime.utils.Assets;
import flixel.FlxState;

class VNState extends OSAState
{
	public static final OUT_LETTER_SPEED:Float = 0.1;
	public static final IN_LETTER_SPEED:Float = 0.03;

	public static var instance:VNState;

	public var _dialogueList:Array<String> = [];

	public var _dialogueEntry(default, set):Int = 0;

	function set__dialogueEntry(value:Int):Int
	{
		if (_dialogueList[value] == null)
		{
			trace('THERE IS NO DIALOGUE LINE AT $value');
			return _dialogueEntry;
		}

		_dialogueLine._rawline = _dialogueList[value];
		trace('Dialogue line at $value : $_dialogueLine');
		return _dialogueEntry = value;
	}

	public var _dialogueLine(default, null):DialogueLine = new DialogueLine(null);

	public var _scene(default, null):String = null;

	public function new(scene:String)
	{
		super();

		if (!'dialogues/$scene'.visualNovelAsset().textFile().fileExists())
		{
			trace('UNFOUND SCENE: $scene');
			scene = 'lorem';
		}

		_dialogueList = scene.parseDialogueFile();

		trace('Dialogue List: ${_dialogueList}');

		this._scene = scene;

		if (instance != null)
		{
			trace('NON-NULL VNSTATE INSTANCE');
			instance = null;
		}

		instance = this;
	}

	public var _dialogueBox:FlxSprite;
	public var _dialogueText:FlxTypeText;

	public var _dialogueContinueHand:FlxSprite;

	public var _dialogueCharacter:DialogueSprite;
	public var _dialogueBG:DialogueSprite;

	public var _eventManager:EventManager;

	public var _dialogueBGGroup:FlxSpriteGroup;
	public var _dialogueCharacterGroup:FlxSpriteGroup;
	public var _dialogueBoxGroup:FlxSpriteGroup;
	public var _dialogueFGGroup:FlxSpriteGroup;
	public var _dialogueUIGroup:FlxSpriteGroup;

	override function create()
	{
		add(_dialogueBGGroup = new FlxSpriteGroup());
		add(_dialogueCharacterGroup = new FlxSpriteGroup());
		add(_dialogueBoxGroup = new FlxSpriteGroup());
		add(_dialogueFGGroup = new FlxSpriteGroup());
		add(_dialogueUIGroup = new FlxSpriteGroup());

		_dialogueBox = new FlxSprite();
		_dialogueBox.makeGraphic(Math.round(FlxG.width * 0.9), Math.round(FlxG.height * 0.4));
		_dialogueBox.screenCenter();
		_dialogueBox.y = FlxG.height * 0.55;

		_dialogueText = new FlxTypeText(_dialogueBox.x, _dialogueBox.y, Math.round(_dialogueBox.width), LoremIpsum.piece, 16);
		_dialogueText.color = FlxColor.BLACK;

		_dialogueText.setTypingVariation(0.75, true);
		_dialogueText.skipKeys = ['SPACE'];

		_dialogueText.sounds = [];
		for (s in ['type1', 'type2', 'type3'])
			_dialogueText.sounds.push(FlxG.sound.load(s.visualNovelAsset().audioFile()));
		_dialogueText.finishSounds = true;

		_dialogueContinueHand = new FlxSprite(0, 0, 'continueHand'.visualNovelAsset().imageFile());
		_dialogueContinueHand.scale.set(2, 2);
		_dialogueContinueHand.updateHitbox();

		_eventManager = new EventManager();
		_eventManager.onCreate();

		_dialogueBGGroup.add(_dialogueBG = new DialogueSprite(false));
		_dialogueCharacterGroup.add(_dialogueCharacter = new DialogueSprite(true));
		_dialogueBoxGroup.add(_dialogueBox);
		_dialogueBoxGroup.add(_dialogueText);
		_dialogueFGGroup.add(_eventManager);
		_dialogueUIGroup.add(_dialogueContinueHand);

		changeLine(0);

		super.create();
	}

	public function getTextFadeOutTime():Float
	{
		if (_dialogueLine._line == null)
			return VNState.OUT_LETTER_SPEED * 'Lorem Ip'.length;

		return _dialogueText.text.length * VNState.OUT_LETTER_SPEED;
	}

	public function changeLine(increment:Int)
	{
		trace('ChangeLine planned');

		if ((_dialogueEntry + increment) > (_dialogueList.length - 1))
		{
			for (object in [
				_dialogueBGGroup,
				_dialogueCharacterGroup,
				_dialogueBoxGroup,
				_dialogueFGGroup,
				_dialogueUIGroup,
			])
			{
				FlxTween.cancelTweensOf(object);
				FlxTween.tween(object, {alpha: 0}, getTextFadeOutTime());
			}

			if (_dialogueLine._line != null)
				_dialogueText.erase(VNState.OUT_LETTER_SPEED, true, null, onEnd);
			else
				FlxTimer.wait(getTextFadeOutTime(), onEnd);

			return;
		}

		if ((_dialogueEntry + increment) < 0)
			return;

		_dialogueEntry += increment;

		_dialogueBox.visible = _dialogueLine._line != null;
		_dialogueText.visible = _dialogueBox.visible;

		resetText();

		buildBGAndCharacter();

		_eventManager.continueLine();
		_ranEvent = _eventManager.runDialogueEvent(_dialogueLine._event);
	}

	public var _ranEvent:Bool = false;

	function resetText()
	{
		_dialogueText.resetText(_dialogueLine?._line ?? '');
		_dialogueText.start(IN_LETTER_SPEED, false, false, null, onDialogueFinishTyping);

		_dialogueTypingFinished = false;
		_dialogueContinueHand.visible = false;

		if (_dialogueLine._line == null && (!_dialogueLine._isEvent && _ranEvent))
			FlxTimer.wait(IN_LETTER_SPEED * LoremIpsum.piece.split(',')[0].length, onDialogueFinishTyping);
	}

	function buildBGAndCharacter()
	{
		_dialogueBG.build(_dialogueLine._bg);
		_dialogueCharacter.build(_dialogueLine._character, () -> positionDialogueCharacter(_dialogueCharacter));
	}

	public static final DEFAULT_DIALOGUEBOX_HEIGHT_PADDING:Float = 0;

	public function positionDialogueCharacter(character:DialogueSprite, ?dialogueBoxHeightPadding:Null<Float>)
	{
		character.y = _dialogueBox.y + (_dialogueBox.height * (dialogueBoxHeightPadding ?? DEFAULT_DIALOGUEBOX_HEIGHT_PADDING)) - character.height;
		if (!_dialogueBox.visible)
			character.y = FlxG.height - character.height;
	}

	public var _dialogueTypingFinished:Bool = false;

	public function onDialogueFinishTyping()
	{
		_dialogueTypingFinished = true;
	}

	public function onEnd()
	{
		trace('End');

		instance = null;
		FlxG.switchState(() -> new TitleState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_dialogueTypingFinished && FlxG.keys.justPressed.ENTER)
			changeLine(1);

		_dialogueContinueHand.visible = _dialogueTypingFinished;
		_dialogueContinueHand.setPosition(_dialogueBox.x
			+ _dialogueBox.width
			- _dialogueContinueHand.width,
			_dialogueBox.y
			+ _dialogueBox.height
			- _dialogueContinueHand.height);
	}
}
