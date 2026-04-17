@echo off

@REM echo ZIPPING: HTML5
cd "export/release/html5/bin/"
@REM wsl zip -9 -Z bzip2 -r "html5-bzip2.zip" *
@REM wsl mv "html5-bzip2.zip" ../../../../export/

@REM echo ZIPPING: WINDOWS
@REM cd "../../../../export/release/windows/bin/"
@REM wsl zip -9 -Z bzip2 -r "windows-bzip2.zip" *
@REM wsl mv "windows-bzip2.zip" ../../../../export/

echo 7ZIPPING: WINDOWS
cd "../../../../export/release/windows/bin/"
wsl 7z a "windows-7zip.zip" *
wsl mv "windows-7zip.zip" ../../../../export/

cd ../../../../