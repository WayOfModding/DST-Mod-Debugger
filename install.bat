@echo off
:: This batch file is written with guidance of dbenham
:: < http://stackoverflow.com/questions/38026918/how-to-retrieve-and-change-last-modification-time-stamp-of-a-file-on-windows >
setlocal

:: setup
set "dataPath=..\..\data\scripts"
set "updatePath=scripts"
set "data=mainfunctions.lua"
set "update=DisplayError.lua"
set "temp=temp.lua"

:: copy: compare date & backup
copy /y "%dataPath%\%data%" "%updatePath%\%temp%" >nul

:: first time, goto update
if not exist "%updatePath%\%data%" (
        echo "First time installation!"
        goto update
)

:: list files in chronological order
:: the last one listed is the newest
for /f "delims=" %%F in (
        'dir /b /od "%updatePath%\%temp%" "%updatePath%\%update%"'
) do set "neweset=%%F"

:: if the newest equals the backup, goto upadte
if "%newest%" equ "%update%" (
        echo "Game is updated, mod is re-installed automatically..."
        goto update
)

echo "Mod is already installed! Exiting..."
del "%updatePath%\%temp%"
exit /b

:: append 
:update
type "%updatepath%\%update%" >> "%dataPath%\%data%"

move /y "%updatePath%\%temp%" "%updatePath%\%data%" >nul

:: touch backup file
copy /b "%updatePath%\%data%"+,, "%updatePath%\%data%" >nul

echo "Installation completed."

exit /b
