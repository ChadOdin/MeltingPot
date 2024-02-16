# Define your Exchange server information
$exchangeServer = "your_exchange_server"

# Prompt user for credentials
$credential = Get-Credential -Message "Enter your Exchange credentials"

# Connect to Exchange server
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$exchangeServer/PowerShell/ -Authentication Kerberos -Credential $credential
Import-PSSession $session -DisableNameChecking -AllowClobber -CommandName *-DistributionGroup

# List the distribution groups
$groups = Get-DistributionGroup

# Iterate through each distribution group
foreach ($group in $groups) {
    Write-Host "Processing group: $($group.DisplayName)"
    
    # Get the members of the distribution group
    $members = Get-DistributionGroupMember -Identity $group.Identity

    # Remove each member
    foreach ($member in $members) {
        Write-Host "Removing user $($member.DisplayName) from group $($group.DisplayName)"
        Remove-DistributionGroupMember -Identity $group.Identity -Member $member.Identity -Confirm:$false
    }
}

# Disconnect from the Exchange server
Remove-PSSession $session

Write-Host "Script Executed Successfully"
