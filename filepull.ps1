$remoteSrv = "\\server\*.msu"
$ext = "*.msu"
$TempStorePath = join-path -Path $env:HOMEDRIVE -ChildPath "\Downloads" 
$TempDIR = "\TempMSUFiles"
$DestPath = Join-Path -Path $TempStorePath -ChildPath $TempDIR
$manifest = Join-Path -Path $DestPath -ChildPath "Manifest.txt"

if (-not (Test-Path -Path $DestPath)){
    try {
        New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
    } catch {
        Write-Error "Failed to creat DIR @$DestPath. `n`n$_."
        exit 1
    }
}

try {
    $files = Get-ChildItem -Path $remoteSrv -Filter $ext -File -ErrorAction SilentlyContinue
} Catch {
    Write-Error "Error accessing $remoteSrv.`nError: $_."
    exit 1
}

foreach($file in $files) {
    $currentFile++
    #$freespace = [io.driveinfo]($DestPath).AvailableFreeSpace

    if ($file = $msuFiles) {
        Write-Warning "Not enough free space on drive to copy $($File.FullName).`nSkipping..."
        continue
    }

    try {
        Copy-Item -path $remoteSrv -Destination $DestPath -force -ErrorAction SilentlyContinue 
        Write-Host -Activity "Copied $($File.FullName) to $DestPath"

        Add-Content -Path $manifest -Value $DestPath+$File.FullName

        #$progress = [int](($currentFile / $TotalFiles) * 100)
        Write-Progress -Activity "Copying Files" -Status "Copying $currentFile of $totalFiles.`n$Progress"
    } catch {
        Write-Error "$_."
    }

}
Write-Host "Copy operation completed.`nManifest saved to $manifest in $tempstorepath"

$TotalFile = $files.Count
$Current = 0

# logic to pull .msu from SMB share ^

$updateDirectory = Read-Host -Prompt "Please enter directory's literal name (I.E C:\users\default\desktop\temp)"
$progressFile = "$updateDirectory\updateProgress.txt"
Write-Host "`nProgress will be written to current terminal and 'updateProgress.txt' in the directory you're storing the .msu files in." -ForegroundColor Green
$msuFiles = Get-ChildItem -Path $updateDirectory -Filter *.msu | Sort-Object Name

if (Test-Path $progressFile) {
    $lastIndex = Get-Content $progressFile | Select-Object -First 1 -OutVariable $filename
} else {
    $lastIndex = -1
}

$startIndex = [int]$lastIndex + 1

for ($i = $startIndex; $i -lt $msuFiles.Count; $i++) {
    $prog = 0
    $msuFile = $msuFiles[$i]
    Write-Host "Installing $($msuFile.Name) ($($i+1) of $($msuFiles.Count))"
    
    Write-Progress -Activity "Installing Updates" -Status "Processing $($msuFile.Name)" -PercentComplete (($i + 1) / $msuFiles.Count * 100)
    
    Start-Process -FilePath "wusa.exe" -ArgumentList "`"$($msuFile.FullName)`" /quiet /norestart" -Wait

    $rebootPending = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue)
    if ($rebootPending) {
        $i | Out-File -FilePath $progressFile -Encoding ascii

        Write-Host "A reboot is required to continue installing updates. Please reboot and re-run the script."
        break
    }
}

if ($i -eq $msuFiles.Count) {
    Remove-Item $progressFile -ErrorAction SilentlyContinue
    Write-Host "All updates have been installed." -ForegroundColor Green
    $prog = 1
}
# Main loop to install ^

if ($prog += 1) {
    foreach($o in $msuFiles) {    
        try {
            Remove-Item -Path $DestPath -Filter '*.msu' -Recurse -Force
            Write-Host "Removed $o from $DestPath."
    } catch {
        Write-Host "Unable to delete $o from $DestPath."
        Write-error "Error: $_."
    } finally {
        $prog = 0
        Write-Host "Exiting."
        }
    }
}

# Logic for cleaup OP ^