# Osin's Side Adventure

It's Osin's time in the spotlight,
after a little detour to Nicom Zone,
Osin and Tirok have returned home to find it in ruin.

A new villian: Thunderbolt has taken over.

It's Osin's time to save the day this time.

## Controls

### Extra

F1 - Crash the Game

(Desktop Only) F3 - Screenshot

### Title Menu Controls

7 - Debug Menu

SPACE - Switch to the Title State (This was a transition test and I never removed the key ¯\\_\(ツ)\_/¯)

SHIFT - Enabling moving the scroll bg

LEFT / A (With SHIFT) - Move BG left

DOWN / S (With SHIFT) - Move BG down

UP / W (With SHIFT) - Move BG up

RIGHT / D (With SHIFT) - Move BG right

### Title Submenu Controls

LEFT / A - Move left (only if SHIFT not pressed)

RIGHT / D - Move right (only if SHIFT not pressed)

ESCAPE - Leave

ENTER - Perform selection function (only if SHIFT not pressed)

Same Scrolling BG Controls as Title Menu

### Story Menu Specific Controls

W / UP - Go to previous filter (only if SHIFT not pressed)

S / DOWN - Go to next filter (only if SHIFT not pressed)

### Visual Novel Controls

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
