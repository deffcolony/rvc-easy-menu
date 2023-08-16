@echo off
title RVC Menu : By Deffcolony
setlocal

REM Envoirement Variables
set "version=v23.7.0"
set "zipversion=7z2301-x64"
set "dir=%~dp0Mangio-RVC-%version%_INFER_TRAIN\Mangio-RVC-%version%\"
set "logfile=%~dp0install-logs.log"

REM Clear log file
echo. > "%logfile%"

REM Menu frontend
:menu
cls
echo What would you like to do?
color 7
echo 1. Install RVC
echo 2. go-web.bat : Voice Training, Voice Cover Creation
echo 3. go-realtime-gui.bat : Voice Changer that is useable with Discord, Steam, etc...
echo 4. Exit
set /p program=Choose Your Destiny: 

if "%program%"=="1" (
    REM Download 7-Zip MSI installer
    bitsadmin /transfer "infertraindwnl" /download /priority FOREGROUND ^
        "https://www.7-zip.org/a/%zipversion%.exe" ^
        "%~dp0%zipversion%.exe" || (
            color 4
            echo [%date% %time%] ERROR: Download failed >>"%logfile%"
            echo ERROR: Download failed. Check the log file at %logfile% for more information.
            pause
            exit /b 1
        )

    REM Install 7-Zip
    echo [%date% %time%] INFO: Launching 7-Zip Installer... >>"%logfile%"
    powershell.exe -nologo -noprofile -command "Start-Process '%~dp0%zipversion%.exe' -Verb runAs"
    pause
    echo [%date% %time%] INFO: 7-Zip Installation complete. >>"%logfile%"

    REM Download the 7z archive
    bitsadmin /transfer "infertraindwnl" /download /priority FOREGROUND ^
        "https://huggingface.co/MangioRVC/Mangio-RVC-Huggingface/resolve/main/Mangio-RVC-%version%_INFER_TRAIN.7z" ^
        "%~dp0Mangio-RVC-%version%_INFER_TRAIN.7z" || (
            color 4
            echo [%date% %time%] ERROR: Download failed >>"%logfile%"
            echo Download failed. Check the log file at %logfile% for more information.
            pause
            exit /b 1
        )

    REM Extract the downloaded 7z archive
    "%ProgramFiles%\7-Zip\7z.exe" x "%~dp0Mangio-RVC-%version%_INFER_TRAIN.7z" -o"%~dp0Mangio-RVC-%version%_INFER_TRAIN" || (
        color 4
        echo [%date% %time%] ERROR: Extraction failed >>"%logfile%"
        echo Extraction failed. 7-Zip is not installed!
        pause
        exit /b 1
    )

    REM Remove the downloaded ZIP archive & 7-Zip installer
::    del "%~dp0Mangio-RVC-%version%_INFER_TRAIN.7z"
    del "%~dp0%zipversion%.exe"

) else if "%program%"=="2" (
    if exist "%dir%\go-web.bat" (
        color a
        echo [%date% %time%] INFO: Starting RVC webui... >>"%logfile%"
        cd "%dir%"
        powershell.exe -nologo -noprofile -command "Start-Process '%dir%\go-web.bat'
    ) else (
        color 4
        echo [%date% %time%] ERROR: File not found: %dir%\go-web.bat >>"%logfile%"
        echo ERROR: File not found. Check the log file at %logfile% for more information.
        pause
    )
) else if "%program%"=="3" (
    if exist "%dir%\go-realtime-gui.bat" (
        color a
        echo [%date% %time%] INFO: Starting RVC realtime gui... >>"%logfile%"
        cd "%dir%"
        powershell.exe -nologo -noprofile -command "Start-Process '%dir%\go-realtime-gui.bat'
    ) else (
        color 4
        echo [%date% %time%] ERROR: File not found: %dir%\go-realtime-gui.bat >>"%logfile%"
        echo ERROR: File not found. Check the log file at %logfile% for more information.
        pause
    )
) else if "%program%"=="4" (
    goto :exit
) else (
    color 6
    echo WARNING: Invalid choice, please choose 1, 2, 3, or 4.
    pause
)

goto :menu

REM Exit the script
:exit
echo [%date% %time%] INFO: Exiting menu... Bye>>"%logfile%"