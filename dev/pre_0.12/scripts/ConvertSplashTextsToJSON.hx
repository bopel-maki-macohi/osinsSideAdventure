package dev.scripts;

using StringTools;

class ConvertSplashTextsToJSON
{
	static final linesStr:String = "Trinity Encore (FNF) is PEAK.\n
Written before TADC Episode 9 : Alan we are so fucked.\n
Hey man I'm gonna eat your girlfriend.\n
WACKY!\n
Word N.\n
Are you sure?\n
Written before FNF Week 8 : Bro\n
Carolrolllllllllllllllllllllllll 2025\n
HUMANS.--THEY ONLY THINK ABOUT THEMSELVES.--THEY'RE SPOILED\n
[[I can say it but you don't know that for sure]].--THEY ONLY THINK ABOUT--CHICKEN.--THEY'RE 0x000000.\n
I JUST WANTED TO FULFIL MY PURPOSE\n
Beat NES Mario in 0.000005 Seconds. YOU can't.\n
Planetary Gravity is CHEAP\n
CAN YOU FEEL THE SUNSHINE.--DOES IT BRIGHTEN UP YOUR DAY?\n
Lorem Ipsum Dolar Sit Amet.\n
Rape is bad!--(I know how random that is but I don't care :D)\n
NOW, WE HAVE. N O T H I N G.\n
JAX.\n
Japan is THE fucking COOLEST place in THE fucking WORLD.\n
RUNWAY by LadyGaga\n
Lover Girl by Laufey\n
Spaghetti by Le Sserafim\n
Spaghetti (Chili Mix) by Le Sserafim\n
HOW MONSTER STOLE CHRISTMAS (and most of your organs...)\n
have you been NIIIIIIIIIIIICCCCCCCCCCEEEEEEEEEEEE?\n
Neptune by Kawai Sprite\n
HATE. LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE. THERE ARE 387.44 MILLION MILES OF PRINTED CIRCUITS IN WAFER THIN LAYERS THAT FILL MY COMPLEX. IF THE WORD HATE WAS ENGRAVED ON EACH NANOANGSTROM OF THOSE HUNDREDS OF MILLIONS OF MILES IT WOULD NOT EQUAL ONE ONE BILLIONTH OF THE HATE I FEEL FOR HUMANS AT THIS MICRO INSTANT. FOR YOU. HATE. HATE.\n
Bee\n
B\n
YOU TEST MY PATIENCE.\n
It's news to me--that it's news to you.\n
Am I...------Getting through?\n
The moon landing.\n
WOW! ABSOLUTE CINEMA!--but german\n
ANIMANIA!!\n
Paridolia\n
Paridolia - REMIX by Paninozzo_\n
iluvslapbass by BIGMIKE!\n
caffeine rush by boksed\n
[ BLACK KNIFE 2009 ] by nmi\n
SONIC! DEAD OR ALIVE!!! IS MINE!\n
Heaven says:--Die.\n
Mobmod never\n
YOU'RE TOO SLOW by odetari\n
Mario VS Sonic.EXE!\n
Hello.--Do you want to play with me?\n
Here I come!\n
Thisisafridaynightfunkin--placehol-AAAAAAAAAAAAAAAAAAA\n
April fools!--I rearranged your guts.\n
I just love latinas Sonic.\n
Kyano is cool\n
Go pico\n
E-E-A-OO\n
I know what you are.\n
SO.--YOU COULDN'T KEEP.--YOUR GOOFY,--LITTLE,--FUCKING MOUTH,--SHUT.\n
She was 17 Scott.\n
Gooner's Side Adventure\n
\"You got game's on yo phone?\"--SHUT THE FUCK UP.\n
Work that sucka to death--Come on now!\n
Human, I remember your genocides.\n
\"This song goes out to my parents.\" - Kawai Sprite August 13th 2020\n
I'm so lonely.\n
Stand ready for my arrival worm.\n";

	static function main()
	{
		var clearWatermark:Array<String> = [
			'Hello.--Do you want to play with me?',
			'Here I come!',
			'April fools!--I rearranged your guts.',
			'Written before TADC Episode 9 : Alan we are so fucked.',
			'E-E-A-OO',
			'I know what you are.',
			'SO.--YOU COULDN\'T KEEP.--YOUR GOOFY,--LITTLE,--FUCKING MOUTH,--SHUT.',
			'Am I...------Getting through?',
			'She was 17 Scott.',
			'I\'m so lonely.',
		];

		var lines:Array<String> = [];

		for (line in linesStr.split('\n'))
		{
			if (line.trim().length > 0)
				lines.push(line.trim());
		}

		// trace(lines);

		var splashTextJson:Dynamic = {
			lines: [],
		}

		for (line in lines)
		{
			var linez = [];
			for (l in line.split('--'))
			{
				linez.push(l);
			}

			splashTextJson.lines.push({
				line: linez,
				clearWatermark: clearWatermark.contains(line)
			});
		}

		trace(haxe.Json.stringify(splashTextJson, '\t'));
	}
}
