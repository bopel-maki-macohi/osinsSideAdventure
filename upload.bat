@echo off

.\dev/compile.bat

echo UPLOADING: HTML5
@REM butler push ./export/release/html5/bin bopel-maki-macohi/osins-side-adventure:html5 --userversion-file version.txt
@REM echo UPLOADING: WINDOWS
@REM butler push ./export/release/windows/bin bopel-maki-macohi/osins-side-adventure:windows --userversion-file version.txt