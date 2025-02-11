# Define Variables
$sourceFolder = "C:\WindowsInstallerFiles"  # Change to your source folder
$usbDriveLetter = "D:"  # Change to your USB drive letter

# Ensure running as admin
$adminCheck = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run PowerShell as Administrator!" -ForegroundColor Red
    exit
}

# Format USB Drive
Write-Host "Formatting $usbDriveLetter..."
$diskpartScript = @"
select volume $usbDriveLetter
clean
create partition primary
format fs=ntfs quick
assign letter=$usbDriveLetter
active
exit
"@
$diskpartScript | Out-File -FilePath "diskpart_script.txt"
Start-Process -FilePath "diskpart" -ArgumentList "/s diskpart_script.txt" -Wait -NoNewWindow
Remove-Item -Force "diskpart_script.txt"

# Copy Windows Installation Files
Write-Host "Copying Windows installation files..."
robocopy "$sourceFolder\" "$usbDriveLetter\" /E /NFL /NDL /NJH /NJS /NC /NS /NP

# Make USB Bootable
Write-Host "Making USB bootable..."
$bootsect = "$usbDriveLetter\boot\bootsect.exe"
Start-Process -FilePath $bootsect -ArgumentList "/NT60 $usbDriveLetter /force /mbr" -Wait -NoNewWindow

Write-Host "Windows Bootable USB is ready!" -ForegroundColor Green
