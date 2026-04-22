@echo off

echo ZIPPING: HTML5
cd "export/release/html5/bin/"
wsl zip -9 -Z bzip2 -r "html5-itchio.zip" *
wsl mv "html5-itchio.zip" ../../../../export/

echo 7ZIPPING: WINDOWS
cd "../../../../export/release/windows/bin/"
wsl 7z a "windows-regular.zip" *
wsl mv "windows-regular.zip" ../../../../export/

cd ../../../../

cd "launchMods"

echo 7ZIPPING: OSA LAUNCH MOD
wsl 7z a "launchMod-osa.zip" "osa"
wsl mv "launchMod-osa.zip" export/

echo 7ZIPPING: BISO LAUNCH MOD
wsl 7z a "launchMod-biso.zip" "biso"
wsl mv "launchMod-biso.zip" export/