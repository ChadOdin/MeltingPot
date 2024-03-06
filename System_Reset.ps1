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

    # Check for existing files on the USB drive
    $csvPath = Join-Path -Path $usbDrive -ChildPath $hostnameFolder
    if (Test-Path $csvPath) {
        $hostnameFolder += "_duplicate"
        Write-Host "Duplicate files found. Appending '_duplicate' tag to the folder name."
    }
    else {
        # Create the hostname folder on the USB drive if it doesn't exist
        New-Item -Path $csvPath -ItemType Directory
    }

    # Check for the "Root" folder on the USB drive
    $rootFolder = Join-Path -Path $usbDrive -ChildPath "Root"
    if (-not (Test-Path $rootFolder)) {
        Write-Host "Error: 'Root' folder not found on the USB drive. Aborting script."
        return
    }

    # Create the full destination path for the CSV file on the USB drive
    $csvDestination = Join-Path -Path $usbDrive -ChildPath $hostnameFolder

    # Export CSV to the new folder on the USB drive
    $csvPath = Join-Path -Path $systemDrive -ChildPath "path\to\your\data.csv"
    Copy-Item -Path $csvPath -Destination $csvDestination

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
