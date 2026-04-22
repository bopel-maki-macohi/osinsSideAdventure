@echo off

echo BUILDING: HTML5
lime build html5 -DINCLUDE_LAUNCH_MODS --times

echo BUILDING: WINDOWS
lime build windows --times

.\dev/zip-itchio.bat