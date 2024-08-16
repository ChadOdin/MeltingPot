$updateDirectory = "C:\"
$progressFile = "$updateDirectory\updateProgress.txt"
$hashFile = "$updateDirectory\Hashs.txt"

# Function to load hashes from Hashs.txt
function Load-Hashes($hashFile) {
    if (Test-Path $hashFile) {
        $hashDictionary = @{}
        $hashLines = Get-Content $hashFile
        foreach ($line in $hashLines) {
            # Expecting the format: <hash> <filename>
            $split = $line -split '\s+'
            if ($split.Length -eq 2) {
                $hash = $split[0].ToLower().Trim()
                $filename = $split[1].ToLower().Trim()
                $hashDictionary[$filename] = $hash
            } else {
                Write-Host "Warning: Skipping malformed line in hash file: $line"
            }
        }
        return $hashDictionary
    } else {
        Write-Host "Error: Hash file not found at $hashFile"
        return $null
    }
}

# Load hashes from the file
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
    $msuFileNameLower = $msuFile.Name.ToLower()

    Write-Host "Verifying $($msuFile.Name) ($($i+1) of $($msuFiles.Count))"

    $fileHash = (Get-FileHash -Path $msuFile.FullName -Algorithm SHA512).Hash.ToLower()

    if ($hashes.ContainsKey($msuFileNameLower)) {
        $expectedHash = $hashes[$msuFileNameLower]
        
        if ($expectedHash -ne $fileHash) {
            Write-Host "Hash mismatch for file $($msuFile.Name)."
            Write-Host "Expected: $expectedHash"
            Write-Host "Found: $fileHash"
            $i | Out-File -FilePath $progressFile -Encoding ascii
            break
        }
    } else {
        Write-Host "Error: No hash entry found for file $($msuFile.Name)."
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
