@echo off
:: Define Variables
set SOURCE_FOLDER=C:\win11_download
set USB_DRIVE=D:

:: Ensure running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run this script as Administrator!
    pause
    exit /b
)

:: Confirm USB Drive
echo WARNING: This will format %USB_DRIVE%. Proceed? (Y/N)
set /p confirm=
if /I not "%confirm%"=="Y" exit /b

:: Format USB Drive
echo Formatting %USB_DRIVE%...
diskpart /s "%~dp0format_script.txt"

:: Copy Windows Installation Files
echo Copying Windows installation files...
xcopy "%SOURCE_FOLDER%\*" "%USB_DRIVE%\" /E /H /C /I /Y

:: Make USB Bootable
echo Making USB bootable...
"%USB_DRIVE%\boot\bootsect.exe" /NT60 %USB_DRIVE% /force /mbr

echo Windows Bootable USB is ready!
pause
