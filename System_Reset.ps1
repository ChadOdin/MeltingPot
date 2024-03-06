# Determine the system drive letter
$systemDrive = $env:SystemDrive

# Get removable drives using Get-Disk, Get-Partition, and Get-Volume
$removableDrives = Get-Disk | Where-Object { $_.BusType -eq 'USB' } | 
                   Get-Partition | Get-Volume | 
                   Select-Object -ExpandProperty DriveLetter

# Find the first available removable drive
$removableDrive = $removableDrives | Select-Object -First 1

# Check if a valid removable drive is found
if ($removableDrive) {
    # Use the hostname as a new folder
    $hostnameFolder = "$env:COMPUTERNAME"
    
    # Check for existing files in removable drive
    $csvPath = Join-Path -Path $removableDrive -ChildPath $hostnameFolder
    if (Test-Path $csvPath) {
        $hostnameFolder += "_duplicate"
        Write-Host "Duplicate files found. Appending '_duplicate' tag to the folder name."
    }

    # Create the full destination path for the CSV file on the removable drive
    $csvDestination = Join-Path -Path $removableDrive -ChildPath $hostnameFolder

    # Export CSV to the new folder on the removable drive
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
    $bitLockerDriveLetter = Get-BitLockerVolume -MountPoint $removableDrive | Select-Object -ExpandProperty DriveLetter

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
    Write-Host "No valid removable drive found. Aborting script."
}
