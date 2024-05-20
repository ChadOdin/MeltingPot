# Run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script! Please run PowerShell as an Administrator."
    exit
}

# Function to show progress
function Show-Progress {
    param (
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete
    )

    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
}

# Function to run SFC
function Run-SFC {
    Show-Progress -Activity "System File Checker" -Status "Starting SFC scan..." -PercentComplete 0
    Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait
    Show-Progress -Activity "System File Checker" -Status "SFC scan complete." -PercentComplete 100
}

# Function to run CHKDSK
function Run-CHKDSK {
    Show-Progress -Activity "Check Disk" -Status "Starting CHKDSK scan..." -PercentComplete 0
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c chkdsk C: /F /R /X" -Wait
    Show-Progress -Activity "Check Disk" -Status "CHKDSK scan scheduled. Please restart your computer to complete the scan." -PercentComplete 100
}

# Function to run DISM
function Run-DISM {
    Show-Progress -Activity "Deployment Imaging Service" -Status "Starting DISM scan..." -PercentComplete 0
    Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait
    Show-Progress -Activity "Deployment Imaging Service" -Status "DISM scan complete." -PercentComplete 100
}

# Function to run Disk Cleanup
function Run-DiskCleanup {
    Show-Progress -Activity "Disk Cleanup" -Status "Starting Disk Cleanup..." -PercentComplete 0
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
    Show-Progress -Activity "Disk Cleanup" -Status "Disk Cleanup complete." -PercentComplete 100
}

# Function to run Windows Update
function Run-WindowsUpdate {
    Show-Progress -Activity "Windows Update" -Status "Starting Windows Update..." -PercentComplete 0
    Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck -AllowClobber
    Import-Module PSWindowsUpdate
    Install-WindowsUpdate -AcceptAll -AutoReboot
    Show-Progress -Activity "Windows Update" -Status "Windows Update complete." -PercentComplete 100
}

# Function to optimize drives
function Optimize-Drives {
    Show-Progress -Activity "Optimize Drives" -Status "Optimizing drives..." -PercentComplete 0
    Optimize-Volume -DriveLetter C -Defrag -Verbose
    Show-Progress -Activity "Optimize Drives" -Status "Drives optimized." -PercentComplete 100
}

# Function to run Windows Defender Scan
function Run-DefenderScan {
    Show-Progress -Activity "Windows Defender" -Status "Starting Defender scan..." -PercentComplete 0
    Start-MpScan -ScanType QuickScan
    Show-Progress -Activity "Windows Defender" -Status "Defender scan complete." -PercentComplete 100
}

# Run maintenance tasks
Write-Host "Starting system maintenance tasks..."
Run-SFC
Run-DISM
Run-CHKDSK
Run-DiskCleanup
Run-WindowsUpdate
Optimize-Drives
Run-DefenderScan
Write-Host "System maintenance tasks completed. Please restart your computer if prompted."

# End of script