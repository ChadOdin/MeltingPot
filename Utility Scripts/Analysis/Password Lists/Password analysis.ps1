function Select-InputFile {
    $validExtensions = @("*.txt", "*.csv")
    $files = Get-ChildItem -Path $scriptRoot -Filter *.txt,*.csv -File
    $customFilePathOption = "Custom filepath"

    if ($files.Count -eq 0) {
        Write-Host "No .txt or .csv files found in the script root directory."
        return $null
    }

    Write-Host "Select an input file:"
    for ($i = 0; $i -lt $files.Count; $i++) {
        Write-Host "$($i + 1): $($files[$i].Name)"
    }
    Write-Host "$($files.Count + 1): $customFilePathOption"

    $selection = Read-Host "Enter the number of the file to use"
    if (-not [int]::TryParse($selection, [ref]$null) -or $selection -lt 1 -or $selection -gt ($files.Count + 1)) {
        Write-Host "Invalid selection. Please enter a number between 1 and $($files.Count + 1)."
        return $null
    }

    if ($selection -eq ($files.Count + 1)) {
        $customFilePath = Read-Host "Enter the custom file path"
        if (-not (Test-Path $customFilePath)) {
            Write-Host "Invalid file path. Please enter a valid file path."
            return $null
        }

        $selectedFile = Get-Item $customFilePath
    }
    else {
        $selectedFile = $files[$selection - 1]
    }

    $extension = $selectedFile.Extension.ToLower()

    if ($extension -notin @(".txt", ".csv")) {
        Write-Host "Invalid file type. Please select a .txt or .csv file."
        return $null
    }

    return $selectedFile.FullName
}

function Count-CharactersAndWords {
    param (
        [string]$filePath,
        [string]$charOutputCSV,
        [string]$wordOutputCSV
    )

    $charCounts = @{}
    $wordCounts = @{}

    Write-Host "Reading file: $filePath"

    $totalFileSize = (Get-Item $filePath).Length
    $processedChars = 0
    $progressWidth = 50

    $streamReader = [System.IO.StreamReader]::new($filePath)

    try {
        while (-not $streamReader.EndOfStream) {
            $data = $streamReader.ReadLine()

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
    exit
}

Write-Host "Script started successfully."

$scriptRoot = Split-Path $MyInvocation.MyCommand.Path

$FilePath = Select-InputFile

if (-not $FilePath) {
    Write-Host "No valid input file selected. Exiting script."
    exit
}

$CharOutputCSV = Join-Path -Path $scriptRoot -ChildPath "character_count_script.csv"
$WordOutputCSV = Join-Path -Path $scriptRoot -ChildPath "word_count_script.csv"

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { On-ScriptExit }

try {
    Count-CharactersAndWords -filePath $FilePath -charOutputCSV $CharOutputCSV -wordOutputCSV $WordOutputCSV
}
catch {
    Write-Host "An error occurred: $_"
    exit 1
}