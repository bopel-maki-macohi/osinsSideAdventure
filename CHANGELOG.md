# 0.9.5 (4/15/2026)

- Fixed Issue 3 not unlocking Issue 4 if you startup the game with issue3 beat

# 0.9.4 (4/15/2026)

- Added an OUTDATED SCREEN! (Desktop only)
  - Displays when there's an update out (on the github) so yeah, you'll be bothered about that when you open the game
- Git info is now in the game window title
- The crash handler now includes git info of the build
- Fixed Tirok / Credits Tile BG having a fliped tile asset
- Issue 3 dialogue tweaks
- A lesser bop scale then the bop scale the issue title in the story menu is about to have no longer forces the scale
- Using [`flixel-controls`](https://github.com/Geokureli/FlxControls/tree/master) for input stuff now
- The Window title is changed at startup now
- The Splash State is now actually it's own state instead of being mixed with InitState
- Changed "PC Name" Option / Save to always be disabled on web
  - Added grayscale shader to the options menu option to display this
  - The options menu option text also changes to display this
- Added package name (com.maki.osa)

# 0.9.3 (4/15/2026)

- Fixed on startup where you're supposed to get issues when you have beat them not happening
  - Example: If you beat issue 4 in 0.9.x and then in 0.10 there's a new issue unlocked via issue 4, before this patch you wouldn't get that issue, now you would.
- Issue 1 is now always considered beat
- Added "Clear Save" debug menu option
- The Story menu now displays the percent complete of the issue

# 0.9.2 (4/15/2026)

- Fixed crashes (and potention) related to the game instance being null
  - More specifically a timer or smth similar was running and th game instance was turnt null right before it ended (for most of them)

# 0.9.1 (4/14/2026)

- Just fixes to the changelog

# 0.9.0 : Issue Pack 1 (4/14/2026)

- **Added Issue 4 (Unlocked through playing issue 3)**
- **Added Issue 3 (Unlocked through playing issue 2)**
- **Added Bonus Issue 1 (Unlocked through issue 2)**

- The texts of all title submenus is now center aligned
- Requazar credit has been changed
- Fixed spamming select on a title option and select to leave causing the menu objects to stick around
- Fixed being able to click title options multiple times via spamming select on the object
- Menus now have sound effects
- The Hold (Space) To Skip Gadge is now centered around the dialogue continue hand
- The debug substate "Get missing assets" option has had changes
- Updated Story Menu! (Again)
  - Issue titles now are pink if you haven't played them
  - Selection and non-selection scaling has been removed from the issue titles (they still bop)
  - Issue titles bop to the music depending on the volume now hehe
  - The story mode text is back (at he top of the screen) and now displays the following:
    - Current Filter
    - Selected Issue Chapter
  - The issue titles now turn yellow when selected
    - red if you haven't beat them
  - Added Filters ((UP / W) / (DOWN / S) to toggle the filter)
    - ALL : Everything
    - ISSUES : Issues only
    - BONUS : Bonus Issues only
    - UNPLAYED : Unplayed issues and bonus issues only
    - CHAPTER 1 : Chapter 1 issues and bonus issues only
- Removed _slightly_ different bop size depending on what index the story menu title is
- Fixed Event Manager not running `update`
- Fixed Visual Novel temp cached textures being cleared from the cache as soon as you leave the caching state
- Holding SPACE to leave no longer counts as a valid exit and thus event runners can use that information now to prevent things such as unlockables
- You now unlock issues by playing the ones before, starting from issue 2
  - Issue2 => Issue3
  - Issue3 => Issue4
  - Etc...
- Changelog file now included in the game build
  - And there's also changelogs for 0.1 - 0.8.1 now

# 0.8.1 (4/13/2026)

- Fixed the Story Menu including non-existant issues

# 0.8.0 : Asset Cache System Update (4/12/2026)

- Storymode \_text is invisible now
- Fixed "Get your ass up" not abiding by the volume when you change it while the song plays
- The Init State transition in is now the default transition in and is faster
- Added Visual Novel Cacher state
- Added Asset Cache System
  - Added option to toggle it

# 0.7.1 (4/12/2026)

- Fixed Crash in issue1 when you leave during tirok's walk
- Fixed substate contents disappearing during transitions on web (solution works for desktop too!)

# 0.7.0 : Issue 2 Update (4/12/2026)

- The Visual Novel now sends you to the Story mode menu
- Fixed timer when a dialogue line is missing
- Added padding to Visual Novel Text
- The Visual Novel Text has doubled in size
- Story Menu Titles are scaled down now
- Added "Get missing assets" debug menu option
- The Init State now has a transition in
- Splash Texts now fade in
- Splash Texts now have a "specialCase" field which runs an InitState function
- Splash Texts now have a "debug" filter, debug build only splash texts (list will be replaced with debug list if there is atleas) at a 25% chance
- Added Target States to TitleSteate
- Added Defines
  - `STORYMENU`
  - `CREDITS`
  - `OPTIONSMENU`
  - `DEBUGMENU`
- Added FPS Counter
  - Added OPtion to toggle
- The new default dialogue speed is 0.05
- Added 3 General use events you can use
  - `event_setDialogueBoxHeightPadding;X`
    - `X` (Float) : How much of the dialogue box's height will be added to the portrait position (dialogueBox.height \* X)
      - Default: 0
  - `event_setDialogueSpeed;X`
    - `X` (Float) : New dialogue speed
      - Default: 0.05
  - `event_resetDialogueSpeed`
- Added Support for event parameters
- Added new splash text
- ADDED ISSUE 2!
- Redrew Story Menu Issue 1 title

# 0.6.1 (4/12/2026)

- Another Web Macro Fix (This time with PCName)

# 0.6.0 : Options Menu Update ( + Overhauled Story Menu) (4/12/2026)

- Fixed substate contents disappearing during transitions
- Removed STORYMODE define
- Fixed Tirok not starting offscreen in Issue 1's Intro
- Added "onEnd" function for Visual Novel events to run
- Added Savedata log to crash messages
- "chapters" savefield is now removed completely
- Removed SPACE to skip visual novel keybind
- Added the ability to hold SPACE to leave the visual novel state
  - Does not run the onEnd function of VNState
- Story Menu v4 (It's a substate now and is like the credits and options menu!)
- Requazar is now apart of the team
- "Get your ass up" is now loaded on startup
- Splash Texts are JSON now
  - More Splash Texts
- Added Debug Menu (SEVEN on the Title State)
- TitleState "Play" button has been redrawn and says "Story"
- Added seperate tile scrolling BG's for options, credits, debug, and story (story is the red from previous versions)
- The tile scrolling BG for the title state is gray now
- Added Options Menu
  - PC Name Option

# 0.5.1 (4/12/2026)

- Credits Text outline doesn't look weird anymore
- Added Dead Code Elimination (I'm pretty should it lowers the filesize but I dont remember, BTS reason is that it makes compiling faster)
- Added VirtuGuy credit

# 0.5.0 : Rhythm Manager Update (+ Chapters renamed to Issues) (4/12/2026)

- Chapters renamed to Issues (including savedata with no backwards compatability)
- Added Rhythm Manager (Yoinked from WTFEngine)
  - Story mode icon and title bop on beat now
- Story Menu v3
- Github Issue Templates

# 0.4.2 (4/12/2026)

- Fixed HTML5 Build (dumb macro thing)

# 0.4.1 (4/12/2026)

- Fixed Screenshots (Were debug only)

# 0.4.0 : Chapter 1 Update (4/12/2026)

- Added Visual Novel event system
- Added Chapter 1
- More splash texts
- Adding the ability to take Screenshots (F3)
- Crash Handler

# 0.3.0 (4/11/2026) : Story Menu Update

- Removed Extra Maki credits
- Added checks for missing scenes
- Visual Novel assets are now all in `assets/visualnovel`
- Added Save
- Story Menu v2
- More splash texts

# 0.2.0 (4/11/2026) : Credits Menu Update

- Prototype Story Menu
- Credits Menu Functionality Changes

# 0.1.0 (4/11/2026)

- Inital Prototype
