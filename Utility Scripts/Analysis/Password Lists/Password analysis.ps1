function Count-CharactersAndWords {
    param (
        [string]$filePath,
        [string]$charOutputCSV,
        [string]$wordOutputCSV
    )

    $charCounts = @{}
    $wordCounts = {}

    try {
        $totalFileSize = (Get-Item $filePath).Length
        $progressWidth = 50
        $processedChars = 0

        $streamReader = [System.IO.StreamReader]::new($filePath)

        while (-not $streamReader.EndOfStream) {
            $line = $streamReader.ReadLine()
            $processedChars += $line.Length

            $line.ToCharArray() | ForEach-Object {
                if ($_ -match '[a-zA-Z0-9]') {
                    $charCounts[$_]++
                }
            }

            $words = $line -split '\W+'
            $words | ForEach-Object {
                if ($_ -match '\w') {
                    $wordCounts[$_]++
                }
            }

            $progress = [Math]::Min(($processedChars / $totalFileSize) * 100, 100)
            $completedChars = [Math]::Floor(($progress / 100) * $progressWidth)
            $remainingChars = $progressWidth - $completedChars
            $progressBar = ('#' * $completedChars) + ('-' * $remainingChars)
            Write-Host ("Progress: [{0}] {1,3}%" -f $progressBar, $progress)
        }

        $charCounts.GetEnumerator() | Sort-Object -Property Key | Select-Object Key, Value | Export-Csv -Path $charOutputCSV -NoTypeInformation
        $wordCounts.GetEnumerator() | Sort-Object -Property Key | Select-Object Key, Value | Export-Csv -Path $wordOutputCSV -NoTypeInformation

        Write-Host "Output saved."
    }
    finally {
        $streamReader.Close()
    }
}

function On-ScriptExit {
    Write-Host "Script exiting..."
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
    Count-CharactersAndWords -filePath $FilePath -charOutputCSV $CharOutputCSV -wordOutputCSV $WordOutputCSV
}

Write-Host "Script started successfully."

$FilePath = Read-Host "Enter the path to the file:"
if (-not (Test-Path $FilePath)) {
    Write-Host "Invalid file path."
    exit
}

$ext = [System.IO.Path]::GetExtension($FilePath)
if (($ext -ne ".txt") -and ($ext -ne ".csv")) {
    Write-Host "Unsupported file format. Please provide a .txt or .csv file."
    exit
}

$CharOutputCSV = Read-Host "Enter the path to save character counts (CSV):"
$WordOutputCSV = Read-Host "Enter the path to save word counts (CSV):"

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
    Count-CharactersAndWords -filePath $FilePath -charOutputCSV $CharOutputCSV -wordOutputCSV $WordOutputCSV
}
catch {
    Write-Host "An error occurred: $_"
    Save-Progress
}
finally {
    Save-Progress
}