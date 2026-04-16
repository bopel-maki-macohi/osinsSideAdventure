@echo off

echo UPLOADING: HTML5
butler push ./export/release/html5/bin bopel-maki-macohi/osins-side-adventure:html5 --userversion-file version.txt
echo UPLOADING: WINDOWS
butler push ./export/release/windows/bin bopel-maki-macohi/osins-side-adventure:windows --userversion-file version.txt