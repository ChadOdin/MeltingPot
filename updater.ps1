
$updateDirectory = "C:\"
$progressFile = "$updateDirectory\updateProgress.txt"

$msuFiles = Get-ChildItem -Path $updateDirectory -Filter *.msu | Sort-Object Name

if (Test-Path $progressFile) {
    $lastIndex = Get-Content $progressFile | Select-Object -First 1
} else {
    $lastIndex = -1
}

$startIndex = [int]$lastIndex + 1

for ($i = $startIndex; $i -lt $msuFiles.Count; $i++) {
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
    Write-Host "All updates have been installed."
}