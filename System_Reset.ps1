# Function to get USB drives
function Get-UsbDrives {
    Get-WmiObject Win32_DiskDrive | Where-Object { $_.InterfaceType -eq 'USB' } | ForEach-Object {
        $_.DeviceID
    }
}

# Determine the system drive letter
$systemDrive = $env:SystemDrive

# Get USB drives
$usbDrives = Get-UsbDrives

# Find the first available USB drive
$usbDrive = $usbDrives | Select-Object -First 1

# Check if a valid USB drive is found
if ($usbDrive) {
    # Use the hostname as a new folder
    $hostnameFolder = "$env:COMPUTERNAME"

    # Create the full path of the parent directory on the USB drive
    $fullParentPath = Join-Path -Path $PSScriptRoot -ChildPath "YourParentDirectory"  # Replace with your desired parent directory path on USB

    # Create the full path of the hostname folder
    $fullFolderPath = Join-Path -Path $fullParentPath -ChildPath $hostnameFolder

    # Check if the directory already exists
    if (-not (Test-Path -Path $fullFolderPath)) {
        try {
            $directory = New-Item -Path $fullFolderPath -ItemType Directory -Force -ErrorAction Stop
            Write-Host "Directory created: $($directory.FullName)"
        }
        catch {
            Write-Host "Error creating directory: $_"
            Write-Host "Aborting script."
            return
        }
    }
    else {
        Write-Host "Directory already exists: $fullFolderPath"
    }

    # Run the batch file from root
    $batchFilePath = Join-Path -Path $usbDrive -ChildPath "YourBatchFile.bat"  # Replace with the actual name of your batch file
    if (Test-Path -Path $batchFilePath) {
        try {
            Start-Process -FilePath $batchFilePath -Wait
            Write-Host "Batch file executed successfully."
        }
        catch {
            Write-Host "Error running batch file: $_"
            Write-Host "Aborting script."
            return
        }
    }
    else {
        Write-Host "Batch file not found: $batchFilePath"
        Write-Host "Aborting script."
        return
    }

    # Export the updated CSV to the hostname folder
    $csvPath = Join-Path -Path $usbDrive -ChildPath "path\to\your\updated\data.csv"  # Replace with the path to the updated CSV
    $csvDestination = Join-Path -Path $fullFolderPath -ChildPath "data.csv"
    try {
        Copy-Item -Path $csvPath -Destination $csvDestination -ErrorAction Stop
        Write-Host "Updated CSV exported to: $($csvDestination)"
    }
    catch {
        Write-Host "Error exporting updated CSV: $_"
        Write-Host "Aborting script."
        return
    }

    # Print both serial numbers to the terminal for review
    $localSerial = (wmic bios get serialnumber).Trim()
    $csvSerial = Import-Csv "$csvDestination\data.csv" | Select-Object -ExpandProperty SerialNumber

    Write-Host "Local Serial Number: $localSerial"
    Write-Host "CSV Serial Number  : $csvSerial"
    Write-Host "Reviewing serial numbers. Pausing for 10 seconds..."
    Start-Sleep -Seconds 10

} else {
    Write-Host "No valid USB drive found. Aborting script."
}
