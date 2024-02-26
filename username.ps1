# Connect to Exchange server
$exchangeCredential = Get-Credential -Message "Enter your Exchange admin credentials"
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$exchangeServer/PowerShell/ -Authentication Kerberos -Credential $exchangeCredential
Import-PSSession $session -DisableNameChecking -AllowClobber -ErrorAction Stop

# Clear the console screen
Clear-Host

# Prompt for distribution group name
$distributionGroupName = Read-Host "Enter distribution group name for all actions"

# Print the header for the Exchange Toolset menu
Write-Host "Exchange Toolset" -ForegroundColor Yellow

# Main menu to choose between adding or removing users from distribution groups
$mainChoice = Read-Host "`nSelect an option:`n1. Adding users to distribution groups`n2. Removing users from distribution groups`nEnter 1 or 2"

if ($mainChoice -eq 1) {
    # Adding users to distribution groups
    # Submenu to choose between adding a single user and adding users from CSV
    $submenuChoice = Read-Host "`nSelect an option:`n1. Add single user to distribution group`n2. Add users from CSV to distribution group`nEnter 1 or 2"

    if ($submenuChoice -eq 1) {
        # Adding a single user to distribution group
        $userUPN = Read-Host "Enter user UPN"
        Add-DistributionGroupMember -Identity $distributionGroupName -Member $userUPN
        Write-Host "Added $userUPN to $distributionGroupName."
        Log-Action "Added $userUPN to $distributionGroupName."
    }
    elseif ($submenuChoice -eq 2) {
        # Adding users from CSV to distribution group
        # Path to the CSV file with UPNs
        $csvPath = Read-Host "Enter the path to the CSV file"

        # Import CSV file
        $userList = Import-Csv $csvPath

        # Iterate through each user in the CSV file and add them to the distribution group
        foreach ($user in $userList) {
            $userUPN = $user.UPN
            Add-DistributionGroupMember -Identity $distributionGroupName -Member $userUPN
            Write-Host "Added $userUPN to $distributionGroupName."
            Log-Action "Added $userUPN to $distributionGroupName."
        }
    }
    else {
        Write-Host "Invalid choice. Please enter 1 or 2."
    }
}
elseif ($mainChoice -eq 2) {
    # Removing users from distribution groups
    # Submenu to choose between removing a single user and removing users from CSV
    $submenuChoice = Read-Host "`nSelect an option:`n1. Remove single user from distribution group`n2. Remove users from CSV from distribution group`nEnter 1 or 2"

    if ($submenuChoice -eq 1) {
        # Removing a single user from distribution group
        $userUPN = Read-Host "Enter user UPN"
        Remove-DistributionGroupMember -Identity $distributionGroupName -Member $userUPN -Confirm:$false
        Write-Host "Removed $userUPN from $distributionGroupName."
        Log-Action "Removed $userUPN from $distributionGroupName."
    }
    elseif ($submenuChoice -eq 2) {
        # Removing users from CSV from distribution group
        # Path to the CSV file with UPNs
        $csvPath = Read-Host "Enter the path to the CSV file"

        # Import CSV file
        $userList = Import-Csv $csvPath

        # Iterate through each user in the CSV file and remove them from the distribution group
        foreach ($user in $userList) {
            $userUPN = $user.UPN
            Remove-DistributionGroupMember -Identity $distributionGroupName -Member $userUPN -Confirm:$false
            Write-Host "Removed $userUPN from $distributionGroupName."
            Log-Action "Removed $userUPN from $distributionGroupName."
        }
    }
    else {
        Write-Host "Invalid choice. Please enter 1 or 2."
    }
}
else {
    Write-Host "Invalid choice. Please enter 1 or 2."
}

# Disconnect from the Exchange server
Remove-PSSession $session


Clear-Host
Write-Host "script exited successfully. All user actions have been logged for
auditing purposes."