# check permissions and elevate using runas

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent() 
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator

   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;

   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";

   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);

   # Exit from the current, unelevated, process
   exit
   }

#--------------- VM creation code -----------------#

function Bootloader-Function {
    Write-Host "Bootloader: Starting OS..."
    Start-Sleep -Seconds 2
    Write-Host "Bootloader: OS successfully loaded."
}

function ShowIPtoTerminal {
    $ip = "ipv4"
    $outfile = "%appdata%/roaming/tmp/tmp.txt"
    $pingme = Get-Content $outfile
    try {
        Invoke-Command mkdir ([Environment]::GetFolderPath($outfile)) "test"
        Invoke-Command ipconfig | select-string $ip | out-file $outfile
        Invoke-Command Test-NetConnection $pingme 
    } catch {

    }

}
function Load-BootloaderFromFile {
    param (
        [string]$BootloaderFilePath
    )

    try {
        # Check if the file exists
        if (-not (Test-Path -Path $BootloaderFilePath)) {
            Write-Host "Bootloader file not found."
            return
        }

        # Load bootloader code from file
        $BootloaderCode = Get-Content -Path $BootloaderFilePath

        # Execute bootloader code
        Invoke-Expression $BootloaderCode
    } catch {
        Write-Host "An error occurred while loading the bootloader: $_"
    }
}

function Select-BootloaderFile {
    try {
        $BootloaderFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1

        if ($BootloaderFiles.Count -eq 0) {
            Write-Host "No bootloader files found in the script directory."
            return
        }

        Write-Host "Bootloader files found in the script directory:"
        for ($i = 0; $i -lt $BootloaderFiles.Count; $i++) {
            Write-Host "$($i+1). $($BootloaderFiles[$i].Name)"
        }

        $choice = Read-Host "Enter the number of the bootloader file you want to use"

        if ($choice -ge 1 -and $choice -le $BootloaderFiles.Count) {
            $selectedFile = $BootloaderFiles[$choice - 1].FullName
            Load-BootloaderFromFile -BootloaderFilePath $selectedFile
        } else {
            Write-Host "Invalid choice. Please select a valid bootloader file."
        }
    } catch {
        Write-Host "An error occurred while selecting the bootloader file: $_"
    }
}

function Select-IsoFile {
    try {
        $DownloadsPath = [Environment]::GetFolderPath("MyDocuments") + "\Downloads"
        $IsoFiles = Get-ChildItem -Path $DownloadsPath -Filter *.iso

        if ($IsoFiles.Count -eq 0) {
            Write-Host "No .iso files found in the Downloads directory."
            return $null
        }

        Write-Host ".iso files found in the Downloads directory:"
        for ($i = 0; $i -lt $IsoFiles.Count; $i++) {
            Write-Host "$($i+1). $($IsoFiles[$i].Name)"
        }

        $choice = Read-Host "Enter the number of the .iso file you want to use"

        if ($choice -ge 1 -and $choice -le $IsoFiles.Count) {
            $selectedFile = $IsoFiles[$choice - 1].FullName
            return $selectedFile
        } else {
            Write-Host "Invalid choice. Please select a valid .iso file."
            return $null
        }
    } catch {
        Write-Host "An error occurred while selecting the .iso file: $_"
        return $null
    }
}

function Create-VM {
    param (
        [string]$VMName,
        [string]$VMPath,
        [int]$VMSizeGB,
        [string]$ISOPath
    )

    try {
        # Check if the VM already exists
        $existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
        if ($existingVM) {
            Write-Host "VM $VMName already exists."
            return
        }

        # Create full VM path
        $FullVMPath = Join-Path -Path $VMPath -ChildPath $VMName

        # Create new virtual switch dynamically
        $SwitchName = "Switch_$VMName"
        New-VMSwitch -Name $SwitchName -SwitchType Internal

        # Create VM
        New-VM -Name $VMName -Path $FullVMPath -MemoryStartupBytes 2GB -SwitchName $SwitchName

        # Set VM Processor count
        Set-VMProcessor -VMName $VMName -Count 2

        # Set VM Memory Dynamic Memory
        Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true -MinimumBytes 512MB -MaximumBytes 16GB -StartupBytes 2GB

        # Add Virtual Disk
        Add-VMHardDiskDrive -VMName $VMName -ControllerType SCSI -ControllerNumber 0 -Path (Join-Path -Path $FullVMPath -ChildPath "$VMName.vhdx") -SizeBytes ($VMSizeGB * 8GB)

        # Attach ISO
        Add-VMDvdDrive -VMName $VMName -Path $ISOPath

        # Start VM
        Start-VM -Name $VMName

        # Wait for VM to start
        Start-Sleep -Seconds 30

        Write-Host "VM $VMName has been created and started."
    } catch {
        Write-Host "An error occurred while creating the VM: $_"
    }
}

# Set default Hyper-V drive location
$DefaultVMPath = "C:\ProgramData\Microsoft\Windows\Hyper-V" # need to add functionality to set default installation path for .vhdx and/or load defaults from doing a multiple recursive drivescan to case match \Hyper-V\

# Load and execute the bootloader code
Select-BootloaderFile 

# May implement default file to load in tools depending on VM usage. I.E win10 with OpenVPN and WSL if i need a clean room

# Select and set ISO file
$selectedIsoFile = Select-IsoFile
if ($selectedIsoFile -ne $null) {
    $ISOPath = $selectedIsoFile
} else {
    # If no ISO files found, prompt the user to specify a custom path
    $ISOPath = Read-Host "No ISO files found in Downloads directory. Please specify the path to the ISO file:"
    if (-not (Test-Path -Path $ISOPath)) {
        Write-Host "The specified ISO file path does not exist. Exiting..."
        Exit
    }
}

# Additional code for VM creation and other functionalities...
