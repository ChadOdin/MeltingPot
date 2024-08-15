$remotePath = "\\server\share"

$fileExtension = "*.msu"

$downloadsPath = [Environment]::GetFolderPath("UserProfile")
$tempDirectory = "Downloads\TempMSUFiles"

$destinationPath = Join-Path -Path $downloadsPath -ChildPath $tempDirectory

$manifestFilePath = Join-Path -Path $destinationPath -ChildPath "Manifest.txt"

if (-not (Test-Path -Path $destinationPath)) {
    try {
        New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
    } catch {
        Write-Error "Failed to create directory $destinationPath. $_"
        exit 1
    }
}

try {
    $files = Get-ChildItem -Path $remotePath -Filter $fileExtension -Recurse -File -ErrorAction Stop
} catch {
    Write-Error "Error accessing remote path $remotePath. $_"
    exit 1
}

try {
    Clear-Content -Path $manifestFilePath -ErrorAction Stop
} catch {
    New-Item -ItemType File -Path $manifestFilePath -Force | Out-Null
}

$totalFiles = $files.Count
$currentFile = 0

foreach ($file in $files) {
    $currentFile++
    $destinationFilePath = Join-Path -Path $destinationPath -ChildPath $file.Name

    $freeSpace = [io.driveinfo]($destinationPath).AvailableFreeSpace
    if ($file.Length -gt $freeSpace) {
        Write-Warning "Not enough disk space to copy $($file.FullName). Skipping."
        continue
    }

    try {
        Copy-Item -Path $file.FullName -Destination $destinationFilePath -Force -ErrorAction Stop
        Write-Host "Copied $($file.FullName) to $destinationFilePath"

        Add-Content -Path $manifestFilePath -Value $destinationFilePath

        $progress = [int](($currentFile / $totalFiles) * 100)
        Write-Progress -Activity "Copying files" -Status "Copying $currentFile of $totalFiles" -PercentComplete $progress
    } catch {
        Write-Error "Failed to copy $($file.FullName). $_"
    }
}

Write-Host "File copy operation completed. Manifest saved to $manifestFilePath"