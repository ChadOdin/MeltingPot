# Define paths and variables
$remoteSrv = "\\server\*.msu"
$ext = "*.msu"
$TempStorePath = Join-Path -Path $env:HOMEDRIVE -ChildPath "Downloads"
$TempDIR = "TempMSUFiles"
$DestPath = Join-Path -Path $TempStorePath -ChildPath $TempDIR
$manifest = Join-Path -Path $DestPath -ChildPath "Manifest.txt"

# Create destination directory if it doesn't exist
if (-not (Test-Path -Path $DestPath)) {
    try {
        New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
    } catch {
        Write-Error "Failed to create directory at $DestPath. Error: $($_.Exception.Message)"
        exit 1
    }
}

# Get the list of files from the remote server
try {
    $files = Get-ChildItem -Path $remoteSrv -Filter $ext -File -ErrorAction SilentlyContinue
} catch {
    Write-Error "Error accessing $remoteSrv. Error: $($_.Exception.Message)"
    exit 1
}

$TotalFiles = $files.Count
$currentFile = 0

# Copy each file to the destination directory
foreach ($file in $files) {
    $currentFile++
    
    # Define the destination file path
    $destFilePath = Join-Path -Path $DestPath -ChildPath $file.Name
    
    try {
        Copy-Item -Path $file.FullName -Destination $destFilePath -Force -ErrorAction SilentlyContinue 
        Write-Host "Copied $($file.FullName) to $destFilePath"
        
        # Add file path to manifest
        Add-Content -Path $manifest -Value $destFilePath
        
        # Update progress
        $progress = [int](($currentFile / $TotalFiles) * 100)
        Write-Progress -Activity "Copying Files" -Status "Copying $currentFile of $TotalFiles" -PercentComplete $progress
    } catch {
        Write-Error "Failed to copy $($file.FullName). Error: $($_.Exception.Message)"
    }
}

Write-Host "Copy operation completed. Manifest saved to $manifest in $TempStorePath"

# Define update installation logic
$updateDirectory = Read-Host -Prompt "Please enter directory's literal name (e.g., C:\users\default\desktop\temp)"
$progressFile = Join-Path -Path $updateDirectory -ChildPath "updateProgress.txt"
Write-Host "`nProgress will be written to current terminal and 'updateProgress.txt' in the directory you're storing the .msu files in." -ForegroundColor Green
$msuFiles = Get-ChildItem -Path $updateDirectory -Filter *.msu | Sort-Object Name

if (Test-Path $progressFile) {
    $lastIndex = Get-Content $progressFile | Select-Object -First 1
} else {
    $lastIndex = -1
}

$startIndex = [int]$lastIndex + 1

$rebootRequired = $false

# Install updates
for ($i = $startIndex; $i -lt $msuFiles.Count; $i++) {
    $msuFile = $msuFiles[$i]
    Write-Host "Installing $($msuFile.Name) ($($i+1) of $($msuFiles.Count))"
    Write-Progress -Activity "Installing Updates" -Status "Processing $($msuFile.Name)" -PercentComplete (($i + 1) / $msuFiles.Count * 100)

    Start-Process -FilePath "wusa.exe" -ArgumentList "`"$($msuFile.FullName)`" /quiet /norestart" -Wait

    $rebootPending = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue)
    if ($rebootPending) {
        $rebootRequired = $true
        $i | Out-File -FilePath $progressFile -Encoding ascii
        Write-Host "A reboot is required. Continuing with the remaining updates..."
    }
}

# Cleanup logic
if ($i -eq $msuFiles.Count) {
    Remove-Item $progressFile -ErrorAction SilentlyContinue
    Write-Host "All updates have been processed." -ForegroundColor Green

    # Remove downloaded .msu files
    foreach ($file in $msuFiles) {
        try {
            Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
            Write-Host "Removed $($file.FullName) from $DestPath."
        } catch {
            Write-Error "Unable to delete $($file.FullName) from $DestPath. Error: $($_.Exception.Message)"
        }
    }

    if ($rebootRequired) {
        Write-Host "A reboot is required to finalize the updates. Please reboot your system at your earliest convenience." -ForegroundColor Yellow
    } else {
        Write-Host "No reboot is required." -ForegroundColor Green
    }
}