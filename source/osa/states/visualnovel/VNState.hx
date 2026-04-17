package osa.states.visualnovel;

import osa.util.Constants;
import osa.save.Save;
import osa.states.transition.VNCacher;
import osa.objects.HoldToPerformGadge;
import flixel.group.FlxSpriteGroup;
import osa.states.menus.TitleState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import osa.states.visualnovel.cutscenes.VideoCutscene;

class VNState extends OSAState
{
	public static final OUT_LETTER_SPEED:Float = 0.1;

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
		return _dialogueEntry = value;
	}

	public var _dialogueLine(default, null):DialogueLine = new DialogueLine(null);

	public var _issue(default, null):String = null;

	public function new(issue:String)
	{
		super();

		if (!'dialogues/$issue'.visualNovelAsset().textFile().fileExists())
		{
			trace('UNFOUND SCENE: $issue');
			issue = 'lorem';
		}

		_dialogueList = issue.parseDialogueFile();

		// trace('Dialogue List: ${_dialogueList}');

		this._issue = issue;

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

	public var _holdToExit:HoldToPerformGadge;

	public var _videoCutscene:VideoCutscene;

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

		_dialogueText = new FlxTypeText(_dialogueBox.x + 10, _dialogueBox.y + 10, Math.round(_dialogueBox.width) - 10, Constants.LOREM_IPSUM, 32);
		_dialogueText.color = FlxColor.BLACK;

		_dialogueText.setTypingVariation(0.75, true);
		// _dialogueText.skipKeys = ['SPACE'];

		_dialogueText.delay = 0.05;

		_dialogueContinueHand = new FlxSprite(0, 0, 'continueHand'.visualNovelAsset().imageFile());
		_dialogueContinueHand.scale.set(2, 2);
		_dialogueContinueHand.updateHitbox();

		_eventManager = new EventManager();

		_holdToExit = new HoldToPerformGadge(FlxColor.RED, function()
		{
			return controls.pressed.HOLD_SKIP;
		}, function()
		{
			onEnd(false);
		});
		_holdToExit.setPosition(FlxG.width - _holdToExit.width - 32, FlxG.height - _holdToExit.height - 32);

		_dialogueBGGroup.add(_dialogueBG = new DialogueSprite(false));
		_dialogueCharacterGroup.add(_dialogueCharacter = new DialogueSprite(true));
		_dialogueBoxGroup.add(_dialogueBox);
		_dialogueBoxGroup.add(_dialogueText);
		_dialogueFGGroup.add(_eventManager);
		_dialogueFGGroup.add(_videoCutscene = new VideoCutscene());
		_dialogueUIGroup.add(_dialogueContinueHand);
		_dialogueUIGroup.add(_holdToExit);

		_videoCutscene._finishCallback.add(function()
		{
			onDialogueFinishTyping();
		});

		_eventManager.onCreate();
		changeLine(0);

		super.create();

		FlxG.mouse.visible = false;
	}

	public function getTextFadeOutTime():Float
	{
		if (_dialogueLine._line == null)
			return VNState.OUT_LETTER_SPEED * 'Lorem Ip'.length;

		return _dialogueText.text.length * VNState.OUT_LETTER_SPEED;
	}

	public var _leaving:Bool = false;

	public function changeLine(increment:Int)
	{
		if ((_dialogueEntry + increment) > (_dialogueList.length - 1))
		{
			_leaving = true;

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
				_dialogueText.erase(VNState.OUT_LETTER_SPEED, true, null, () -> onEnd(true));
			else
				FlxTimer.wait(getTextFadeOutTime(), () -> onEnd(true));

			return;
		}

		if ((_dialogueEntry + increment) < 0)
			return;

		_dialogueEntry += increment;

		_dialogueBox.visible = _dialogueLine._line != null;
		_dialogueText.visible = _dialogueBox.visible;

		reloadDialogueSFX();
		resetText();

		buildBGAndCharacter();

		_eventManager.continueLine();
		_ranEvent = _eventManager.runDialogueEvent(_dialogueLine._event, _dialogueLine._eventParams);
	}

	public var _ranEvent:Bool = false;

	public var _typingSoundMapID:String = '';

	public function reloadDialogueSFX()
	{
		var typingSoundMapID:String = 'default';
		var charTypingsoundMapID:String = 'default';

		if (_dialogueLine?._character != null)
		{
			charTypingsoundMapID = _dialogueLine?._character.split('-')[0];
			charTypingsoundMapID = haxe.io.Path.withoutDirectory(charTypingsoundMapID);
		}

		if (Constants.TYPING_SOUNDS.exists(charTypingsoundMapID))
			typingSoundMapID = charTypingsoundMapID;

		if (typingSoundMapID != _typingSoundMapID)
		{
			setDialogueSFX(typingSoundMapID);
		}
	}

	public function setDialogueSFX(typingSoundMapID:String)
	{
		_typingSoundMapID = typingSoundMapID;

		if (_dialogueText.sounds != null)
			for (sound in _dialogueText.sounds)
			{
				_dialogueText.sounds.remove(sound);
				sound.destroy();
			}

		_dialogueText.sounds = [];
		_dialogueText.finishSounds = typingSoundMapID == 'default';

		for (sound in Constants.TYPING_SOUNDS.get(typingSoundMapID))
			_dialogueText.sounds.push(FlxG.sound.load(sound.audioFile().visualNovelAsset()));

		// trace('new typing sound map id: $typingSoundMapID');
	}

	function resetText()
	{
		_dialogueText.resetText(_dialogueLine?._line ?? '');
		_dialogueText.start(_dialogueText.delay, false, false, null, onDialogueFinishTyping);

		_dialogueTypingFinished = false;
		_dialogueContinueHand.visible = false;

		if (_dialogueLine._line == null)
		{
			if (_dialogueLine._isEvent && _ranEvent)
				return;

			FlxTimer.wait(_dialogueText.delay * Constants.LOREM_IPSUM.length, onDialogueFinishTyping);
		}
	}

	function buildBGAndCharacter()
	{
		_dialogueBG.build(_dialogueLine._bg);
		_dialogueCharacter.build(_dialogueLine._character, () -> positionDialogueCharacter(_dialogueCharacter));
	}

	public static final DEFAULT_DIALOGUEBOX_HEIGHT_PADDING:Float = 0;

	public var _dialogueBoxHeightPadding:Null<Float> = null;

	public function positionDialogueCharacter(character:DialogueSprite, ?dialogueBoxHeightPadding:Null<Float>)
	{
		character.y = _dialogueBox.y
			+ (_dialogueBox.height * (dialogueBoxHeightPadding ?? _dialogueBoxHeightPadding ?? DEFAULT_DIALOGUEBOX_HEIGHT_PADDING))
			- character.height;
		if (!_dialogueBox.visible)
			character.y = FlxG.height - character.height;
	}

	public var _dialogueTypingFinished:Bool = false;

	public function onDialogueFinishTyping()
	{
		_dialogueTypingFinished = true;
	}

	public function onEnd(validEnd:Bool)
	{
		// trace('End');

		_eventManager.onEnd(validEnd);

		if (validEnd)
		{
			Save.beatIssue(_issue);
		}

		instance = null;
		FlxG.switchState(() -> new TitleState('STORYMENU'));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_videoCutscene.isPlaying() && _dialogueTypingFinished)
			_dialogueTypingFinished = false;

		if (_dialogueTypingFinished && controls.justPressed.ACCEPT)
			changeLine(1);

		_dialogueContinueHand.visible = _dialogueTypingFinished;
		_dialogueContinueHand.setPosition(_dialogueBox.x
			+ _dialogueBox.width
			- _dialogueContinueHand.width,
			_dialogueBox.y
			+ _dialogueBox.height
			- _dialogueContinueHand.height);

		_holdToExit.setPosition(_dialogueBox.x
			+ _dialogueBox.width
			- (_holdToExit.width / 1.5),
			_dialogueBox.y
			+ _dialogueBox.height
			- (_holdToExit.height / 1.5));
	}

	public static function build(issue:String):VNCacher
	{
		return new VNCacher(new VNState(issue), issue);
	}
}
