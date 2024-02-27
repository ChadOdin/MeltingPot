# Function to add or remove users from distribution group
function ManageDistributionGroup {
    param (
        [string]$action,
        [string]$userUPN
    )

    switch ($action) {
        'Add' {
            Add-DistributionGroupMember -Identity $distributionGroupName -Member $userUPN
            Write-Host "Added $userUPN to $distributionGroupName."
            Log-Action "Added $userUPN to $distributionGroupName."
        }
        'Remove' {
            Remove-DistributionGroupMember -Identity $distributionGroupName -Member $userUPN -Confirm:$false
            Write-Host "Removed $userUPN from $distributionGroupName."
            Log-Action "Removed $userUPN from $distributionGroupName."
        }
        default {
            Write-Host "Invalid choice. Please enter 'Add' or 'Remove'."
        }
    }
}

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

switch ($mainChoice) {
    1 {
        # Adding users to distribution groups
        # Submenu to choose between adding a single user and adding users from CSV
        $submenuChoice = Read-Host "`nSelect an option:`n1. Add single user to distribution group`n2. Add users from CSV to distribution group`nEnter 1 or 2"

        switch ($submenuChoice) {
            1 {
                # Adding a single user to distribution group
                $userUPN = Read-Host "Enter user UPN"
                ManageDistributionGroup -action 'Add' -userUPN $userUPN
            }
            2 {
                # Adding users from CSV to distribution group
                $csvPath = Read-Host "Enter the path to the CSV file"
                $userList = Import-Csv $csvPath

                foreach ($user in $userList) {
                    ManageDistributionGroup -action 'Add' -userUPN $user.UPN
                }
            }
            default {
                Write-Host "Invalid choice. Please enter 1 or 2."
            }
        }
    }
    2 {
        # Removing users from distribution groups
        $submenuChoice = Read-Host "`nSelect an option:`n1. Remove single user from distribution group`n2. Remove users from CSV from distribution group`nEnter 1 or 2"

        switch ($submenuChoice) {
            1 {
                # Removing a single user from distribution group
                $userUPN = Read-Host "Enter user UPN"
                ManageDistributionGroup -action 'Remove' -userUPN $userUPN
            }
            2 {
                # Removing users from CSV from distribution group
                $csvPath = Read-Host "Enter the path to the CSV file"
                $userList = Import-Csv $csvPath

                foreach ($user in $userList) {
                    ManageDistributionGroup -action 'Remove' -userUPN $user.UPN
                }
            }
            default {
                Write-Host "Invalid choice. Please enter 1 or 2."
            }
        }
    }
    default {
        Write-Host "Invalid choice. Please enter 1 or 2."
    }
}

# Disconnect from the Exchange server
Remove-PSSession $session

Clear-Host
Write-Host "Script exited successfully. All user actions have been logged for auditing purposes."
