# Function to get USB drives
function Get-UsbDrives {
    Get-WmiObject Win32_DiskDrive | Where-Object { $_.InterfaceType -eq 'USB' } | ForEach-Object {
        $_.DeviceID
    }
}

# Determine the system drive letter
$systemDrive = $env:SystemDrive

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

    # Create the full path of the hostname folder
    $fullFolderPath = Join-Path -Path $fullParentPath -ChildPath $hostnameFolder

    # Check for existing files on the USB drive
    if (Test-Path $fullFolderPath) {
        $hostnameFolder += "_duplicate"
        Write-Host "Duplicate files found. Appending '_duplicate' tag to the folder name."
    }

    # Create the hostname folder on the USB drive if it doesn't exist
    try {
        New-Item -Path $fullFolderPath -ItemType Directory -ErrorAction Stop
    }
    catch {
        Write-Host "Error creating directory: $_"
        Write-Host "Aborting script."
        return
    }

    # Create the full destination path for the CSV file on the USB drive
    $csvDestination = Join-Path -Path $usbDrive -ChildPath $fullFolderPath

    # Export CSV to the new folder on the USB drive
    $csvPath = Join-Path -Path $usbDrive -ChildPath "path\to\your\data.csv"  # Replace with the path on the USB drive
    try {
        Copy-Item -Path $csvPath -Destination $csvDestination -ErrorAction Stop
    }
    catch {
        Write-Host "Error copying CSV file: $_"
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

    # Determine the BitLocker-protected drive dynamically
    $bitLockerDriveLetter = Get-BitLockerVolume -MountPoint $usbDrive | Select-Object -ExpandProperty DriveLetter

    if ($bitLockerDriveLetter) {
        $password = Read-Host "Enter BitLocker password" -AsSecureString

        # Unlock the BitLocker-protected drive
        Unlock-BitLocker -MountPoint $bitLockerDriveLetter -Password $password

        try {
            # Perform your actions after unlocking the BitLocker drive
            # For example, you can access files or perform other operations on the unlocked drive
            Get-ChildItem -Path $bitLockerDriveLetter

            # Continue with the rest of the script...

            # Check serial number again after review
            $localSerial = (wmic bios get serialnumber).Trim()
            $csvSerial = Import-Csv "$csvDestination\data.csv" | Select-Object -ExpandProperty SerialNumber

            # Switch statement to handle different cases
            switch ($localSerial) {
                $csvSerial {
                    # Serial numbers match
                    $reset = Read-Host "Are you ready to initiate a system reset? (Y/N)"
                    switch ($reset) {
                        'Y' {
                            Start-Process -FilePath "systemreset.exe" -ArgumentList "/force /cleanpc" -Wait
                            # No need for Resume-BitLocker here since it's a system wipe
                        }
                        'N' {
                            Write-Host "System reset aborted."
                        }
                        default {
                            Write-Host "Invalid input. System reset aborted."
                        }
                    }
                }
                default {
                    # Serial numbers do not match
                    Write-Host "Serial numbers do not match. Aborting system reset."
                }
            }
        } finally {
            # Lock the BitLocker-protected drive after completing the actions
            Lock-BitLocker -MountPoint $bitLockerDriveLetter
        }
    } else {
        Write-Host "BitLocker-protected drive not found. Aborting script."
    }

} else {
    Write-Host "No valid USB drive found. Aborting script."
}
