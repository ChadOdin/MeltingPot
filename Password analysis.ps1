function Count-CharactersAndWords {
    param (
        [string]$filePath,
        [string]$charOutputCSV,
        [string]$wordOutputCSV,
        [int]$bufferSize = 65536 # 64kb buffer
    )

    Write-Host "Reading file: $filePath"

    $charCounts = @{}
    $wordCounts = @{}
    $totalFileSize = (Get-Item $filePath).Length
    $readBufferSize = [Math]::Min($totalFileSize, $bufferSize)
    $processedChars = 0
    $progressWidth = 50

    $fileStream = [System.IO.File]::OpenRead($filePath)
    $streamReader = [System.IO.StreamReader]::new($fileStream)

    $buffer = New-Object byte[] $readBufferSize

    try {
        while ($streamReader.Peek() -ne -1) {
            $bytesRead = $streamReader.BaseStream.Read($buffer, 0, $buffer.Length)
            $data = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $bytesRead)

            $data.ToCharArray() | ForEach-Object {
                if ($_ -match '[a-zA-Z0-9]') {
                    $charCounts[$_]++
                    $processedChars++
                }
            }

            $words = $data -split '\W+'
            $words | ForEach-Object {
                if ($_ -match '\w') {
                    $wordCounts[$_]++
                }
            }

            $progress = [Math]::Min(($processedChars / $totalFileSize) * 100, 100)
            $completedChars = [Math]::Floor(($progress / 100) * $progressWidth)
            $remainingChars = $progressWidth - $completedChars
            $progressBar = ('#' * $completedChars) + ('-' * $remainingChars)
            Write-Host ("Processing file`nProgress: [{0}] {1,3}%" -f $progressBar, $progress)
        }

        $charCounts.GetEnumerator() | Sort-Object -Property Key | Select-Object Key, Value | Export-Csv -Path $charOutputCSV -NoTypeInformation
        $wordCounts.GetEnumerator() | Sort-Object -Property Key | Select-Object Key, Value | Export-Csv -Path $wordOutputCSV -NoTypeInformation

        Write-Host "Output saved."
    }
    finally {
        $streamReader.Close()
        $fileStream.Close()
    }
}

function On-ScriptExit {
    Write-Host "Script 2 exiting..."
    $activeJobs = Get-Job -State Running
    if ($activeJobs) {
        Write-Host "Waiting for active jobs to complete..."
        Wait-Job -Job $activeJobs
    }
    Save-Progress
    exit
}

function Save-Progress {
    Write-Host "Script exiting, saving progress..."
    Count-CharactersAndWords -filePath $FilePath -charOutputCSV $CharOutputCSV -wordOutputCSV $WordOutputCSV -bufferSize 65536
}

Write-Host "Script started successfully."

$FilePath = "C:\path\to\your\file.txt"
$CharOutputCSV = "C:\path\to\output\character_count_script2.csv"
$WordOutputCSV = "C:\path\to\output\word_count_script2.csv"

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { On-ScriptExit }

$null = [System.Console]::TreatControlCAsInput = $false
while ($true) {
    if ([System.Console]::KeyAvailable) {
        $key = [System.Console]::ReadKey($true)
        if (($key.Modifiers -band [System.ConsoleModifiers]::Control) -and ($key.Key -eq [System.ConsoleKey]::C)) {
            Write-Host "Ctrl+C detected. Exiting script..."
            Save-Progress
        }
    }
    Start-Sleep -Milliseconds 100
}

try {
    Count-CharactersAndWords -filePath $FilePath -charOutputCSV $CharOutputCSV -wordOutputCSV $WordOutputCSV -bufferSize 65536
}
catch {
    Write-Host "An error occurred: $_"
    Save-Progress
}
finally {
    Save-Progress
}