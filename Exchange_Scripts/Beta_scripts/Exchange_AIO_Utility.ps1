if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force
}

function Show-Menu {
    Clear-Host
    Write-Host "Select a menu option to run`n"
    Write-Host "1: Bulk Addition to Distribution Group`n"
    Write-Host "2: Bulk Removal from Distribution Group`n"
    Write-Host "3: Singular Addition to Distribution Group`n"
    Write-Host "4: Singular Removal from Distribtution Group`n"
    Write-Host "5: Mailbox Creation`n"
    Write-Host "6: Bulk Addition to Calendar`n"
    Write-Host "7: Bulk Removal from Calendar`n"
    Write-Host "8: Single Addition to Calendar`n"
    Write-Host "9: Single Removal from calendar`n"



}

do {
    
} until (
    $choice -eq 10
) {
    show-menu
    $choice = Read-Host -Prompt "Enter Choice of Operation"

    switch ($choice) {
        1 {
            Write-Host "Bulk Addition to Distribution Group Selected"
            $Group = Read-Host -Prompt "Please specify group"
            $csv = Read-Host -Prompt "Please specify path for CSV file"
        
            Connect-ExchangeOnline
            Import-CSV $csv | ForEach-Object {Add-DistributionGroupMember -Identity $Group -Member $_.UPN}
    }
        2 {
            Write-Host "Bulk Removal to Distribution Group Selected"
            $Group = Read-Host -Prompt "Please specify group"
            $csv = Read-Host -Prompt "Please specify path for CSV file"

            Connect-ExchangeOnline
            Import-CSV $csv | ForEach-Object {Remove-DistributionGroupMember -Identity $Group -Member $_.UPN}   
        }

        3 {
            Write-Host "Singular Addition to Distribution Group"
            $user = Read-Host -Prompt "Please Specify Users Email I.E (First.Last@placesforpeople.co.uk NOT payroll)"
            $Group = Read-Host -Prompt "Please specify the Distribution Group"

            Connect-ExchangeOnline
            Add-DistribtuionGroupMemeber -Identity $Group -Member $user
        }

        4 {
            Write-Host "Singular Addition to Distribution Group"
            $user = Read-Host -Prompt "Please Specify Users Email I.E (First.Last@placesforpeople.co.uk NOT payroll)"
            $Group = Read-Host -Prompt "Please specify the Distribution Group"
    
            Connect-ExchangeOnline
            Add-DistribtuionGroupMemeber -Identity $Group -Member $user
        }
        
        5{
            $alias = Read-Host -Prompt "Enter Mailbox Alias"
            $name = Read-Host -Prompt "Enter Mailbox Name"
            $First = Read-Host -Prompt "Enter First Name"
            $Last = Read-Host -Prompt "Enter Last Name"
            $SAM = Read-Host -Prompt "Enter SAM"
            $UPN = Read-Host -Prompt "Enter UPN `n This Script automatically appends the full email address so only enter the desired display name for the email address"

            $credentials = Get-Credential
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://server/Powershell/ -Authentication Kerberos -Credential $credentials
            Import-PSSession $Session
            New-Remotemailbox -Shared -Alias $alias -Name $name -FirstName $First -LastName $Last -OnPremisesOrganizationalUnit "OU=Shared Mailbox 365,OU=Other,OU=Service Desk,DC=group,DC=net" -SamAccountName $SAM -UserPrincipalName $UPN@placesforpeople.co.uk
        }

        6{
            $Credentials = Get-Credential
            $Session = New-PSSession -ConfiguartionName Microsoft.Exchange -ConnectionUri http://server/Powershell/ -Authentication Kerberos -Credential $credentials
            Import-PSSession $Session

            $UserMailbox = Read-host -Prompt "Enter Mailbox"
            $csvpath = Read-host -Prompt "Enter CSV Path"
            $accessList = Import-Csv -Path $csvpath

            foreach ($access in $accessList) {
                $whoNeedsAccess = $access.UPN
                Add-MailboxFolderPermission -Identity "$UsersMailbox:\Calendar" -User $whoNeedsAccess -AccessRights Reviewer
                Set-MailboxFolderPermission -Identity "$UsersMailbox:\Calendar" -User $whoNeedsAccess -AccessRights Reviewer
            }
        }

        7 {
            $Credentials = Get-Credential
            $Session = New-PSSession -ConfiguartionName Microsoft.Exchange -ConnectionUri http://server/Powershell/ -Authentication Kerberos -Credential $credentials
            Import-PSSession $Session

            $UserMailbox = Read-host -Prompt "Enter Mailbox"
            $csvpath = Read-host -Prompt "Enter CSV Path"
            $accessList = Import-Csv -Path $csvpath

            foreach ($access in $accessList) {
                $whoNeedsAccess = $access.UPN
                Add-MailboxFolderPermission -Identity "$UsersMailbox:\Calendar" -User $whoNeedsAccess -AccessRights None
                Set-MailboxFolderPermission -Identity "$UsersMailbox:\Calendar" -User $whoNeedsAccess -AccessRights None
        }

        8 {
            Write-Host "Single Addition to calendar"
            $Credentials = Get-Credential
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mbx900004/Powershell/ -Authentication Kerberos -Credential $Credentials

            $UserMailbox = Read-Host -Prompt "Enter Mailbox"
            $useradd = Read-Host -Prompt "Enter User's UPN"

            Add-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $useradd -AccessRights Reviewer
            Set-MailboxFolderPermission -Identity "$UserMailbox:\Calendar" -User $useradd -AccessRights Reviewer

        }

        }
        default {write-host "invalid Choice"
    }
  }
}
