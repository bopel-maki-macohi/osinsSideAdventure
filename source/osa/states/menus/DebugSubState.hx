package osa.states.menus;

import osa.states.visualnovel.EventManager;
import osa.states.visualnovel.DialogueSprite;
import osa.states.visualnovel.DialogueLine;
import osa.states.visualnovel.VNState;
import flixel.FlxG;
import osa.save.Save;

class DebugSubState extends TitleSubStateBase
{
	override public function new(onExit:Void->Void)
	{
		super(onExit);

		_spriteList = [
			makeSprite('debug/default', () -> return 'Get missing assets', getMissingAssets),

			makeSprite('debug/default', () -> return 'Crash The Game', () -> throw 'DebugSubState Crash'),

			makeSprite('debug/default', () -> return 'Log Save', () -> Save.logSaveData()),
			makeSprite('debug/default', () -> return 'Reset Game', resetGame),

			makeSprite('debug/default', () -> return 'Go to Splash', () -> FlxG.switchState(() -> new InitState())),
			makeSprite('debug/default', () -> return 'Go to Github Page', () -> FlxG.openURL('https://github.com/bopel-maki-macohi/osinsSideAdventure')),
			makeSprite('debug/default', () -> return 'Go to Lorem Ipsum VN', () -> FlxG.switchState(() -> new VNState('lorem'))),
		];
	}

	public static function resetGame()
	{
		OSACache.wipeCaches();

		FlxG.signals.postStateSwitch.remove(OSACache.postStateSwitch);
		FlxG.signals.postUpdate.remove(OSACache.postUpdate);

		FlxG.resetGame();
	}

	function getMissingAssets()
	{
		var chars:Array<String> = [];
		var bgs:Array<String> = [];
		var events:Array<String> = [];

		for (issue in Save.ISSUE_ORDER_PREFERENCE)
		{
			trace(issue);

			for (rawline in issue.parseDialogueFile())
			{
				var dialogueLine:DialogueLine = new DialogueLine(rawline);

				if (dialogueLine._isEvent)
				{
					if (!EventManager.events.exists(dialogueLine._event))
					{
						if (!events.contains(dialogueLine._event))
						{
							trace(' - event: ${dialogueLine._event}}');
							events.push(dialogueLine._event);
						}
					}

					continue;
				}

				final char = dialogueLine._character;
				final bg = dialogueLine._bg;

				final charPath = '${DialogueSprite.CHARACTERS_FOLDER}/$char'.visualNovelAsset().imageFile();
				final bgPath = '${DialogueSprite.BACKGROUNDS_FOLDER}/$bg'.visualNovelAsset().imageFile();

				if (char != null)
					if (!charPath.fileExists() && !chars.contains(charPath))
					{
						trace(' - char: ${charPath.replace('characters/'.visualNovelAsset(), '')}}');
						chars.push(charPath);
					}

				if (bg != null)
					if (!bgPath.fileExists() && !bgs.contains(bgPath))
					{
						trace(' - bg: ${bgPath.replace('backgrounds/'.visualNovelAsset(), '')}');
						bgs.push(bgPath);
					}
			}
		}
	}
}
