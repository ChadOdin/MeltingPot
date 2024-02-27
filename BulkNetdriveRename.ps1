# Set the path to the shared network drive
$drivePath = "\\your\shared\network\drive\path"

# Get all files in the specified path
$files = Get-ChildItem -Path $drivePath

# Iterate through each file and rename it
foreach ($file in $files) {
    # Extract the current file name
    $currentName = $file.Name

    # Extract file extension
    $extension = $file.Extension

    # Extract date part from the current name
    $datePart = $currentName -match '\d{2}-\d{2}-\d{4}' -replace '.*?(\d{2}-\d{2}-\d{4}).*', '$1'

    # Create the new file name format
    $newName = "UPRN~$datePart#LGSR$extension"

    # Construct the full path for the new name
    $newPath = Join-Path -Path $drivePath -ChildPath $newName

    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newName -Force
}

Write-Host "Bulk rename completed for $drivePath"
