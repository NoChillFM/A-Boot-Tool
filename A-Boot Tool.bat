@echo off
::Change the below to the folder path of your installation media
set SOURCE_FOLDER=C:\WindowsInstallerFiles
set SOURCE_FOLDER=%SOURCE_FOLDER%
set USB_DRIVE=%USB_DRIVE%:

:START
cls
echo =====================
echo      A-Boot Tool
echo =====================
echo.
echo Available drives:
wmic logicaldisk get deviceid, volumename, description
echo.
set /p USB_DRIVE="Enter the drive letter: "
::Randomly broke until I added this gem
for /f "delims=:" %%I in ("%USB_DRIVE%") do set USB_DRIVE=%%I:

::Quick debug
if not exist "%SOURCE_FOLDER%" (
    echo ERROR: Source folder %SOURCE_FOLDER% not found!
    pause
    exit /b
)
if not exist "%USB_DRIVE%" (
    echo ERROR: USB drive %USB_DRIVE% not found!
    pause
    goto START
)

echo.
echo %USB_DRIVE% selected
set /p confirm="Is this the correct drive? (Y/N): "
if /I not "%confirm%"=="Y" (
    echo Operation canceled.
    pause
    goto START
)


echo Formatting %USB_DRIVE%...
(
echo select volume %USB_DRIVE%
echo clean
echo create partition primary
echo format fs=ntfs quick
::It will assign itself a new drive letter after it's active if USB_DRIVE isn't specified
echo assign letter=%USB_DRIVE%
echo active
echo exit
) | diskpart

:: Robocopy parameters
:: /E     - Copy all
:: /MT:   - Multithreading
:: /J     - Large file handler
:: /ZB    - Crash protection
:: /NP    Disabled- No progress display
echo Copying Windows installation files...
robocopy "%SOURCE_FOLDER%" "%USB_DRIVE%" /E /MT:64 /J /ZB

echo Making USB bootable...
if exist "%USB_DRIVE%\boot\bootsect.exe" (
    "%USB_DRIVE%\boot\bootsect.exe" /NT60 %USB_DRIVE% /force /mbr
) else (
    echo ERROR: bootsect.exe not found!
    pause
    exit /b
)

echo =========================================
echo      That's what I'm talking a-boot!
echo       $Boot tool locked and loaded$
echo =========================================
echo.
set /p repeat="How a-boot another? (Y/N): "
if /I "%repeat%"=="Y" goto START
echo Exiting...
pause
exit
