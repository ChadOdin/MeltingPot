function Show-Menu {
    Clear-Host
    Write-Host "Select a menu option to run`n"
    Write-Host "1: Bulk Addition to Distribution Group`n"
    Write-Host "2: Bulk Removal from Distribution Group`n"
    Write-Host "3: Singular Addition to Distribution Group`n"
    Write-Host "4: Singular Removal from Distribution Group`n"
    Write-Host "5: Mailbox Creation`n"
    Write-Host "6: Bulk Addition to Calendar`n"
    Write-Host "7: Bulk Removal from Calendar`n"
    Write-Host "8: Single Addition to Calendar`n"
    Write-Host "9: Single Removal from Calendar`n"
    Write-Host "10: Exit`n"
}

function Connect-Exchange {
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force
    }
    Connect-ExchangeOnline -UserPrincipalName your-email@domain.com -ShowProgress $true
}

function Get-MailboxLocation($mailbox) {
    try {
        $mailboxDetails = Get-Mailbox -Identity $mailbox -ErrorAction Stop
        if ($mailboxDetails.RecipientTypeDetails -eq 'UserMailbox') {
            return 'Cloud'
        } elseif ($mailboxDetails.RecipientTypeDetails -eq 'MailUser') {
            return 'OnPrem'
        } else {
            throw "Unable to determine mailbox location for $mailbox"
        }
    } catch {
        throw "Error fetching mailbox location for $mailbox: $_"
    }
}

do {
    Show-Menu
    $choice = Read-Host -Prompt "Enter Choice of Operation"

    switch ($choice) {
        1 {
            Write-Host "Bulk Addition to Distribution Group Selected"
            $Group = Read-Host -Prompt "Please specify group"
            $csv = Read-Host -Prompt "Please specify path for CSV file"
            Connect-Exchange
            Import-CSV $csv | ForEach-Object {Add-DistributionGroupMember -Identity $Group -Member $_.UPN}
        }
        2 {
            Write-Host "Bulk Removal from Distribution Group Selected"
            $Group = Read-Host -Prompt "Please specify group"
            $csv = Read-Host -Prompt "Please specify path for CSV file"
            Connect-Exchange
            Import-CSV $csv | ForEach-Object {Remove-DistributionGroupMember -Identity $Group -Member $_.UPN}
        }
        3 {
            Write-Host "Singular Addition to Distribution Group"
            $user = Read-Host -Prompt "Please Specify User's Email"
            $Group = Read-Host -Prompt "Please specify the Distribution Group"
            Connect-Exchange
            Add-DistributionGroupMember -Identity $Group -Member $user
        }
        4 {
            Write-Host "Singular Removal from Distribution Group"
            $user = Read-Host -Prompt "Please Specify User's Email"
            $Group = Read-Host -Prompt "Please specify the Distribution Group"
            Connect-Exchange
            Remove-DistributionGroupMember -Identity $Group -Member $user
        }
        5 {
            $alias = Read-Host -Prompt "Enter Mailbox Alias"
            $name = Read-Host -Prompt "Enter Mailbox Name"
            $First = Read-Host -Prompt "Enter First Name"
            $Last = Read-Host -Prompt "Enter Last Name"
            $SAM = Read-Host -Prompt "Enter SAM"
            $UPN = Read-Host -Prompt "Enter UPN (This script automatically appends the full email address so only enter the desired display name for the email address)"
            $credentials = Get-Credential
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://server/Powershell/ -Authentication Kerberos -Credential $credentials
            Import-PSSession $Session
            New-RemoteMailbox -Shared -Alias $alias -Name $name -FirstName $First -LastName $Last -OnPremisesOrganizationalUnit "OU=Shared Mailbox 365,OU=Other,OU=Service Desk,DC=group,DC=net" -SamAccountName $SAM -UserPrincipalName "$UPN@placesforpeople.co.uk"
        }
        6 {
            Write-Host "Bulk Addition to Calendar Selected"
            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $csvpath = Read-Host -Prompt "Enter CSV Path"
            $accessList = Import-Csv -Path $csvpath

            Connect-Exchange

            $location = Get-MailboxLocation $UserMailbox

            foreach ($access in $accessList) {
                $whoNeedsAccess = $access.UPN
                try {
                    if ($location -eq 'Cloud') {
                        Add-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $whoNeedsAccess -AccessRights Reviewer
                        Set-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $whoNeedsAccess -AccessRights Reviewer
                    } elseif ($location -eq 'OnPrem') {
                        # Replace with the on-premises equivalent cmdlets or actions if needed
                        Add-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $whoNeedsAccess -AccessRights Reviewer
                        Set-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $whoNeedsAccess -AccessRights Reviewer
                    }
                    Write-Host "Permissions added for $whoNeedsAccess on $UserMailbox"
                } catch {
                    Write-Error "Failed to add permissions for $whoNeedsAccess on $UserMailbox"
                }
            }
        }
        7 {
            Write-Host "Bulk Removal from Calendar Selected"
            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $csvpath = Read-Host -Prompt "Enter CSV Path"
            $accessList = Import-Csv -Path $csvpath

            Connect-Exchange

            $location = Get-MailboxLocation $UserMailbox

            foreach ($access in $accessList) {
                $whoNeedsAccess = $access.UPN
                try {
                    if ($location -eq 'Cloud') {
                        Remove-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $whoNeedsAccess
                    } elseif ($location -eq 'OnPrem') {
                        # Replace with the on-premises equivalent cmdlets or actions if needed
                        Remove-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $whoNeedsAccess
                    }
                    Write-Host "Permissions removed for $whoNeedsAccess on $UserMailbox"
                } catch {
                    Write-Error "Failed to remove permissions for $whoNeedsAccess on $UserMailbox"
                }
            }
        }
        8 {
            Write-Host "Single Addition to Calendar Selected"
            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $useradd = Read-Host -Prompt "Enter User's UPN"

            Connect-Exchange

            $location = Get-MailboxLocation $UserMailbox

            try {
                if ($location -eq 'Cloud') {
                    Add-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $useradd -AccessRights Reviewer
                    Set-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $useradd -AccessRights Reviewer
                } elseif ($location -eq 'OnPrem') {
                    # Replace with the on-premises equivalent cmdlets or actions if needed
                    Add-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $useradd -AccessRights Reviewer
                    Set-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $useradd -AccessRights Reviewer
                }
                Write-Host "Permissions added for $useradd on $UserMailbox"
            } catch {
                Write-Error "Failed to add permissions for $useradd on $UserMailbox"
            }
        }
        9 {
            Write-Host "Single Removal from Calendar Selected"
            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $userremove = Read-Host -Prompt "Enter User's UPN"

            Connect-Exchange

            $location = Get-MailboxLocation $UserMailbox

            try {
                if ($location -eq 'Cloud') {
                    Remove-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $userremove
                } elseif ($location -eq 'OnPrem') {
                    # Replace with the on-premises equivalent cmdlets or actions if needed
                    Remove-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $userremove
                }
                Write-Host "Permissions removed for $userremove on $UserMailbox"
            } catch {
                Write-Error "Failed to remove permissions for $userremove on $UserMailbox"
            }
        }
        10 {
            Write-Host "Exiting..."
        }
        default {
            Write-Host "Invalid Choice"
        }
    }
} until ($choice -eq 10)

# Disconnect from Exchange Online if connected
if (Get-PSSession -ComputerName "ExchangeOnline" -ErrorAction SilentlyContinue) {
    Disconnect-ExchangeOnline -Confirm:$false
}