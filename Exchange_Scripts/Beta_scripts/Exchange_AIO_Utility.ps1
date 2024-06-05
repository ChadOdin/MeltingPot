function Show-Menu {
    Clear-Host
<<<<<<< HEAD
    Write-Host "Select a menu option to run`n
1: Bulk Addition to Distribution Group`n
2: Bulk Removal from Distribution Group`n
3: Singular Addition to Distribution Group`n
4: Singular Removal from Distribtution Group`n
5: Mailbox Creation`n
6: Bulk Addition to Calendar`n
7: Bulk Removal from Calendar`n
8: Single Addition to Calendar`n
9: Single Removal from calendar`n
10: Bulk Addition to Mailbox`n
11: Bulk Removal from Mailbox
12: Exit
"
=======
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
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e

<<<<<<< HEAD
=======
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
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
}

do {
    Show-Menu
    $choice = Read-Host -Prompt "Enter Choice of Operation"

    switch ($choice) {
        1 {
            Clear-Host
            Write-Host "Bulk Addition to Distribution Group Selected"
            $Group = Read-Host -Prompt "Please specify group"
            $csv = Read-Host -Prompt "Please specify path for CSV file"
            Connect-Exchange
            Import-CSV $csv | ForEach-Object {Add-DistributionGroupMember -Identity $Group -Member $_.UPN}
        }
        2 {
<<<<<<< HEAD
            Clear-Host
            Write-Host "Bulk Removal to Distribution Group Selected"
=======
            Write-Host "Bulk Removal from Distribution Group Selected"
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
            $Group = Read-Host -Prompt "Please specify group"
            $csv = Read-Host -Prompt "Please specify path for CSV file"
            Connect-Exchange
            Import-CSV $csv | ForEach-Object {Remove-DistributionGroupMember -Identity $Group -Member $_.UPN}
        }
        3 {
            Clear-Host
            Write-Host "Singular Addition to Distribution Group"
            $user = Read-Host -Prompt "Please Specify User's Email"
            $Group = Read-Host -Prompt "Please specify the Distribution Group"
            Connect-Exchange
            Add-DistributionGroupMember -Identity $Group -Member $user
        }
        4 {
<<<<<<< HEAD
            Clear-Host
            Write-Host "Singular Addition to Distribution Group"
            $user = Read-Host -Prompt "Please Specify Users Email I.E (First.Last@placesforpeople.co.uk NOT payroll)"
=======
            Write-Host "Singular Removal from Distribution Group"
            $user = Read-Host -Prompt "Please Specify User's Email"
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
            $Group = Read-Host -Prompt "Please specify the Distribution Group"
            Connect-Exchange
            Remove-DistributionGroupMember -Identity $Group -Member $user
        }
<<<<<<< HEAD
        
        5{
            Clear-Host
            Write-Host "Mailbox Creation"
=======
        5 {
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
            $alias = Read-Host -Prompt "Enter Mailbox Alias"
            $name = Read-Host -Prompt "Enter Mailbox Name"
            $First = Read-Host -Prompt "Enter First Name"
            $Last = Read-Host -Prompt "Enter Last Name"
<<<<<<< HEAD
            $SAM = Read-Host -Prompt "Enter SAM. (This counts as a payroll so make sure it matches the mailbox in some capacity I.E SrcSpt")
            $UPN = Read-Host -Prompt "Enter UPN `n This Script automatically appends the full email address so only enter the desired display name for the email address"

=======
            $SAM = Read-Host -Prompt "Enter SAM"
            $UPN = Read-Host -Prompt "Enter UPN (This script automatically appends the full email address so only enter the desired display name for the email address)"
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
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

<<<<<<< HEAD
        6{
            Clear-Host
            Write-Host "Bulk Addition to Calendar"
            $Credentials = Get-Credential
            $Session = New-PSSession -ConfiguartionName Microsoft.Exchange -ConnectionUri http://mbx900004.group.net/Powershell/ -Authentication Kerberos -Credential $credentials
            Import-PSSession $Session
=======
            Connect-Exchange
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e

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
<<<<<<< HEAD
            Clear-Host
            Write-Host "Bulk Removal from Calendar"
            $Credentials = Get-Credential
            $Session = New-PSSession -ConfiguartionName Microsoft.Exchange -ConnectionUri http://mbx900004.group.net/Powershell/ -Authentication Kerberos -Credential $credentials
            Import-PSSession $Session

            $UserMailbox = Read-host -Prompt "Enter Mailbox"
            $csvpath = Read-host -Prompt "Enter CSV Path"
=======
            Write-Host "Bulk Removal from Calendar Selected"
            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $csvpath = Read-Host -Prompt "Enter CSV Path"
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
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
<<<<<<< HEAD
            Clear-Host
            Write-Host "Single Addition to calendar"
            $Credentials = Get-Credential
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mbx900004/Powershell/ -Authentication Kerberos -Credential $Credentials

=======
            Write-Host "Single Addition to Calendar Selected"
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
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

<<<<<<< HEAD
        9{
            Clear-Host
            Write-Host "Single Removal from Calendar"

            $Credentials = Get-Credential
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mbx900004/Powershell/ -Authentication Kerberos -Credential $Credentials

            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $useradd = Read0Host -Prompt "Enter User's UPN"

            Add-MailboxFolderPermission -Identity "$UserMailbx:\Calendar" -User $useradd -AccessRights Reviewer
            Set-MailboxFolderPermission -Identity "$userMailbox:\Calendar" -User $useradd -AccessRights Reviewer
=======
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
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
        }
<<<<<<< HEAD

        }
        default {write-host "invalid Choice"
=======
        10 {
            Write-Host "Exiting..."
        }
        default {
            Write-Host "Invalid Choice"
        }
>>>>>>> 076a487b324c8fa762a8f3921e61a982d12ba36e
    }
} until ($choice -eq 10)

# Disconnect from Exchange Online if connected
if (Get-PSSession -ComputerName "ExchangeOnline" -ErrorAction SilentlyContinue) {
    Disconnect-ExchangeOnline -Confirm:$false
}