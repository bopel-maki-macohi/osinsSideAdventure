@echo off

echo ZIPPING: HTML5
cd "export/release/html5/bin/"
wsl zip -9 -Z bzip2 -r "html5-bzip2.zip" *
wsl mv "html5-bzip2.zip" ../../../../export/

echo ZIPPING: WINDOWS
cd "../../../../export/release/windows/bin/"
wsl zip -9 -Z bzip2 -r "windows-bzip2.zip" *
wsl mv "windows-bzip2.zip" ../../../../export/

cd ../../../../