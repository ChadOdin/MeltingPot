# Hyper-V VM Configuration
$VMNamePrefix = "VM" # Change this prefix to suit your naming convention
$MemoryStartup = 2GB
$MemoryMinimum = 1GB
$CPUCount = 2
$ISOPath = "C:\Path\To\Your\ISO\File.iso"
$VMFolderPath = "C:\Path\To\Your\VMs"

# Menu for user input
Write-Host "Hyper-V VM Automation Script"
$VMCount = Read-Host "Enter the number of VMs to create"

# Validate user input
if (-not $VMCount -or $VMCount -lt 1) {
    Write-Host "Invalid input. Please enter a valid number of VMs."
    Exit
}

# Loop to create VMs
for ($i = 1; $i -le $VMCount; $i++) {
    $VMName = "$VMNamePrefix$i"

    # Create VM
    New-VM -Name $VMName -MemoryStartupBytes $MemoryStartup -MemoryMinimumBytes $MemoryMinimum -SwitchName "YourVirtualSwitch"

    # Set CPU Count
    Set-VMProcessor -VMName $VMName -Count $CPUCount

    # Set VM DVD Drive for ISO
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath

    # Set VM Boot Order
    Set-VMFirmware -VMName $VMName -FirstBootDevice $VMName

    # Set VM Automatic Start Action
    Set-VMAutomaticStartAction -VMName $VMName -StartAction Start

    # Set VM Automatic Stop Action
    Set-VMAutomaticStopAction -VMName $VMName -StopAction ShutDown

    # Set VM Dynamic Memory
    Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true

    # Set VM Path
    Set-VM -VMName $VMName -Path $VMFolderPath

    # Start VM
    Start-VM -Name $VMName
}

Write-Host "VM creation completed."
