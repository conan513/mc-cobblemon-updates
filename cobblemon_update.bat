@echo off
title Beachboys Cobblemon Updater
color 0A
cls

echo ============================================
echo      BEACHBOYS COBBLEMON UPDATER
echo ============================================
echo.

REM --- Játék könyvtár ---
set "GAME_DIR=%LOCALAPPDATA%\BeachboysCobblemon\game"

REM --- Letöltött ZIP neve ---
set "ZIPFILE=%TEMP%\cobblemon_update.zip"

REM --- GitHub Release URL ---
set "URL=https://github.com/conan513/mc-cobblemon-updates/releases/download/up1/cobblemon_update.zip"

REM --- mindig töröljük a régi fájlt ---
if exist "%ZIPFILE%" del /f /q "%ZIPFILE%"

echo [1/4] Letoltes indul...

if exist "%ZIPFILE%" del /f /q "%ZIPFILE%"

powershell -NoLogo -NoProfile -Command ^
    "$url='%URL%'; $out='%ZIPFILE%';" ^
    "$req = [System.Net.HttpWebRequest]::Create($url);" ^
    "$resp = $req.GetResponse();" ^
    "$total = $resp.ContentLength;" ^
    "$stream = $resp.GetResponseStream();" ^
    "$fs = New-Object IO.FileStream($out,[IO.FileMode]::Create);" ^
    "$buffer = New-Object byte[] 8192;" ^
    "$read = 0; $count = 0;" ^
    "while(($count = $stream.Read($buffer,0,$buffer.Length)) -gt 0) {" ^
    "  $fs.Write($buffer,0,$count);" ^
    "  $read += $count;" ^
    "  $percent = [int](($read*100)/$total);" ^
    "  $bars = '#' * ($percent/2);" ^
    "  [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop);" ^
    "  [System.Console]::Write(('Letoltes: [{0,-50}] {1}%%' -f $bars,$percent));" ^
    "}" ^
    "$fs.Close(); $stream.Close(); $resp.Close();" ^
    "[System.Console]::WriteLine();" ^
    "Write-Host 'Letoltes kesz!' -ForegroundColor Green"

echo.

REM --- ellenőrzés: fájl létezik és mérete rendben ---
if not exist "%ZIPFILE%" (
    color 0C
    echo HIBA: a letoltes nem sikerult!
    pause
    exit /b
)

for %%A in ("%ZIPFILE%") do set size=%%~zA
if %size% LSS 1000000 (
    color 0C
    echo HIBA: a letoltott fajl tul kicsi, valoszinuleg hibas!
    pause
    exit /b
)

echo [2/4] Regi config es mods torlese...
rmdir /s /q "%GAME_DIR%\config"
rmdir /s /q "%GAME_DIR%\mods"

echo [3/4] Kicsomagolas...
cd /d "%GAME_DIR%"
tar -xf "%ZIPFILE%"

echo [4/4] Frissites kesz!
echo.

color 0B
echo ============================================
echo   A Cobblemon kliens sikeresen frissult!
echo ============================================
echo.
pause
