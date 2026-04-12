# Osin's Side Adventure

It's Osin's time in the spotlight,
after a little detour to Nicom Zone,
Osin and Tirok have returned home to find it in ruin.

A new villian: Thunderbolt has taken over.

It's Osin's time to save the day this time.

## Visual Novel Controls

SPACE - Hold to leave to the title screen

ENTER - Proceed through dialogue when the hand shows up

## Compiling

1. Install [Haxe](https://haxe.org/download/)

2. Run the following:
   - `haxelib install hmm --global`
   - `haxelib run hmm install --global`

3. Perform additional platform setup
   - For Windows, download the [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
     - When prompted, select "Individual Components" and make sure to download the following:
     - MSVC v143 VS 2022 C++ x64/x86 build tools
     - Windows 10/11 SDK
   - Mac: [`lime setup mac` Documentation](https://lime.openfl.org/docs/advanced-setup/macos/)
   - Linux: [`lime setup linux` Documentation](https://lime.openfl.org/docs/advanced-setup/linux/)
   - HTML5: Compiles without any extra setup

Now do `lime test <ur platform>` and you are good.
