if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force
}

$credential = get-credential
connect-exchange 
new-pssession $session -URI "https://server/powershell/" -authentication Kerberos -credential $credentials -AllowClobber -disablenamechecking

import-pssession $session

$UsersMailbox = Read-Host -Prompt "Enter the calendar email"

$csvPath = read-host "Please enter .CSV directory:"

$accessList = Import-Csv -Path $csvPath

foreach ($access in $accessList) {
    $WhoNeedsAccess = $access.UPN

    # adding temp reviewer access
    Add-MailboxFolderPermission -Identity "$UsersMailbox:\Calendar" -User $WhoNeedsAccess -AccessRights Reviewer

# setting permanent reviewer permissions 
Set-MailboxFolderPermissions -Identity $UserMailbox:\Calendar" -User $WhoNeedsAccess -AccessRights Reviewer
}
