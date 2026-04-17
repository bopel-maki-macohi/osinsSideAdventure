@echo off

echo ZIPPING: HTML5
cd "export/release/html5/bin/"
wsl zip -9 -Z bzip2 -r "html5.zip" *
wsl mv "html5.zip" ../../../../export/

echo 7ZIPPING: WINDOWS
cd "../../../../export/release/windows/bin/"
wsl 7z a "windows.zip" *
wsl mv "windows.zip" ../../../../export/

cd ../../../../