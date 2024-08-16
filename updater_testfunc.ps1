$updateDirectory = "C:\"
$progressFile = "$updateDirectory\updateProgress.txt"
$hashFile = "$updateDirectory\Hashs.txt"

# calculate SHA-512 hash of a file
function Get-FileHashSha512($filePath) {
    $hashAlgorithm = [System.Security.Cryptography.SHA512]::Create()
    try {
        $fileStream = [System.IO.File]::OpenRead($filePath)
        $hashBytes = $hashAlgorithm.ComputeHash($fileStream)
        $fileStream.Close()
        return [BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()
    } catch {
        Write-Host "Error: Unable to calculate hash for file $filePath"
        return $null
    }
}

# load hashes from Hashs.txt
function Load-Hashes($hashFilePath) {
    if (Test-Path $hashFilePath) {
        $hashDictionary = @{}
        $hashLines = Get-Content $hashFilePath
        foreach ($line in $hashLines) {
            $split = $line -split '\s+'
            if ($split.Length -eq 2) {
                $hashDictionary[$split[1].ToLower()] = $split[0].ToLower()
            }
        }
        return $hashDictionary
    } else {
        Write-Host "Error: Hash file not found at $hashFilePath"
        return $null
    }
}

# load hashes from the file
$hashes = Load-Hashes $hashFile
if ($hashes -eq $null) {
    exit 1
}

$msuFiles = Get-ChildItem -Path $updateDirectory -Filter *.msu | Sort-Object Name

if (Test-Path $progressFile) {
    $lastIndex = Get-Content $progressFile | Select-Object -First 1
} else {
    $lastIndex = -1
}

$startIndex = [int]$lastIndex + 1

for ($i = $startIndex; $i -lt $msuFiles.Count; $i++) {
    $msuFile = $msuFiles[$i]
    Write-Host "Verifying $($msuFile.Name) ($($i+1) of $($msuFiles.Count))"

    $fileHash = Get-FileHashSha512 $msuFile.FullName

    if ($fileHash -eq $null -or $hashes[$msuFile.Name.ToLower()] -ne $fileHash) {
        Write-Host "Hash mismatch for file $($msuFile.Name). Skipping installation."
        $i | Out-File -FilePath $progressFile -Encoding ascii
        break
    }

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
