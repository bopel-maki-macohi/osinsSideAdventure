@echo off

echo BUILDING: HTML5
lime build html5 --times

echo BUILDING: WINDOWS
lime build windows --times

.\dev/zip.bat